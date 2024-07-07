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
                    SearchBar(text: .constant(""), isDummy: true)
                        .onTapGesture {
                            store.send(.presentSearchView)
                        }
                    
                    Text("스크랩")
                        .font(.system(size: 24, weight: .bold))
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Self.gridSpacing),
                            GridItem(.flexible(), spacing: Self.gridSpacing)
                        ],
                        spacing: Self.gridSpacing
                    ) {
                        ForEach(store.media) { content in
                            let playTime: TimeInterval? = {
                                if case let .video(time) = content.contentType {
                                    return time
                                } else {
                                    return nil
                                }
                            }()
                            
                            MediaCell(
                                imageURL: content.thumbnailURL,
                                playTime: playTime,
                                date: content.datetime
                            )
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
