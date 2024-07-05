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
                    Button {
                        store.send(.presentScrap)
                    } label: {
                        Text("showDetail")
                    }
                    
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
        @Presents var destination: Destination.State? // 하위에 state를 주입할 수 있음
        
        public init() { }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>) // 하위에서 일어난 action을 받을 수 있음
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
