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
import Kingfisher

public struct ScrapView: View {
    @Perception.Bindable var store: StoreOf<ScrapFeature>
    
    var mediaRepository = KakaoImageRepository()
    
    public init(store: StoreOf<ScrapFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading) {
                    Button {
                        store.send(.presentSearchView)
                    } label: {
                        Text("Go Search")
                    }
                    
                    Text("스크랩")
                        .font(.headline)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Self.gridSpacing),
                            GridItem(.flexible(), spacing: Self.gridSpacing)
                        ],
                        spacing: Self.gridSpacing
                    ) {
                        ForEach(store.media) { content in
                            KFImage(URL(string: content.thumbnailURL)!)
                                .fade(duration: 0.5)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(ScrapView.imageRadius)
                        }
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
                .padding(Self.gridSpacing)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

// MARK: - View Contant
extension ScrapView {
    static let gridSpacing: CGFloat = 8
    static let imageRadius: CGFloat = 4
}

// MARK: - Preview
#Preview {
    ScrapView(
        store: Store(
            initialState:
                ScrapFeature.State()
        ) {
            ScrapFeature()
        }
    )
}

