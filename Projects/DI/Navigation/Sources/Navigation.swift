//
//  Navigation.swift
//  Scrap
//
//  Created by DOYEON LEE on 7/5/24.
//

import SwiftUI

import ScrapFeature
import SearchFeature

import ComposableArchitecture

@available(*, deprecated, "16.0 이하 버전과의 호환성을 위해 TCA Navigation tree-based 방식으로 전환했습니다. 화면전환은 루트 컴포넌트가 아닌 각 뷰에서 담당합니다.")
public struct RootNavigationView<Content: View>: View {
    @Perception.Bindable var store: StoreOf<NavigationFeature>
    
    let content: () -> Content
    
    public init(
        store: StoreOf<NavigationFeature>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            NavigationView {
                VStack {
                    content()
                    
                    // MARK: ScrapView
                    NavigationLink(
                        item: $store.scope(
                            state: \.destination?.scrap,
                            action: \.destination.scrap
                        ),
                        onNavigate: { _ in },
                        destination: { destinationStore in
                            ScrapView(
                                store: destinationStore
                            )
                        },
                        label: { }
                    )
                    
                    // MARK: SearchView
                    NavigationLink(
                        item: $store.scope(
                            state: \.destination?.search,
                            action: \.destination.search
                        ),
                        onNavigate: { _ in },
                        destination: { destinationStore in
                            SearchView(
                                store: destinationStore
                            )
                        },
                        label: { }
                    )
                }
            }
        }
    }
}

@Reducer
public struct NavigationFeature {
    @Reducer
    public enum Destination {
        case scrap(ScrapFeature)
        case search(SearchFeature)
    }
    
    @ObservableState
    public struct State {
        @Presents public var destination: Destination.State? // child view에 state를 전달
        
        public init() { }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>) // child view에서 일어난 action을 받기
        case presentScrap
    }
    
    public init() { }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.scrap(.presentSearch))):
                state.destination = .search(.init())
                return .none
            case .presentScrap:
                state.destination = .scrap(.init())
                return .none
            case .destination(.dismiss):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
