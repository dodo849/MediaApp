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
                VStack(alignment: .leading, spacing: 16) {
                    SearchBar(text: .constant(""), isDummy: true)
                        .onTapGesture {
                            store.send(.presentSearchView)
                        }
                    
                    HStack {
                        Image(systemName: "archivebox")
                            .resizable()
                            .frame(width: 22, height: 22)
                        Text("스크랩")
                            .font(.system(size: 24, weight: .bold))
                    }
                    
                    if store.media.isEmpty {
                        emptyScrapView
                    } else {
                        mediaList
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
                .padding(Self.pageSpacing)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    var mediaList: some View {
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
    }
    
    var emptyScrapView: some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.bin")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Text("스크랩된 미디어가 없습니다")
                .font(.body)
        }
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, Self.screenHeight / 3)
    }
}

// MARK: - View Contant
extension ScrapView {
    static let pageSpacing: CGFloat = 16
    static let gridSpacing: CGFloat = 8
    static let imageRadius: CGFloat = 4
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
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
