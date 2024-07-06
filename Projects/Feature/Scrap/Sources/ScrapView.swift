//
//  ScrapView.swift
//  Scrap
//
//  Created by DOYEON LEE on 7/5/24.
//

import SwiftUI

import CommonFeature
import SearchFeature
import MediaNetwork

import ComposableArchitecture

public struct ScrapView: View {
    @Perception.Bindable var store: StoreOf<ScrapFeature>
    
    var mediaRepository = KakaoImageRepository()
    
    public init(store: StoreOf<ScrapFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                Button {
                    store.send(.presentSearchView)
                } label: {
                    Text("Show SearchView")
                }
                
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
