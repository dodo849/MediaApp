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
    public typealias ViewAction = ScrapFeature.ViewAction
    public typealias ViewState = ScrapFeature.State
    
    private var originStore: StoreOf<ScrapFeature> // for navigation destination binding
    @Perception.Bindable private var store: Store<ViewState, ViewAction>
    
    public init(store: StoreOf<ScrapFeature>) {
        self.store = store.scope(
            state: \.self,
            action: \.view
        )
        self.originStore = store
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
                }
                .padding(Self.pageSpacing)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .background {
                NavigationLinkStore(
                    originStore.scope(
                        state: \.$destination.search,
                        action: \.destination.search
                    ),
                    onTap: { },
                    destination: { SearchView(store: $0) },
                    label: { EmptyView() }
                )
            }
        }
    }
    
    @ViewBuilder
    var mediaList: some View {
        HStack(alignment: .top) {
            LazyVGrid(columns: [.init(.flexible())]) {
                ForEach(Array(store.media.enumerated()
                    .filter { $0.offset.isMultiple(of: 2) }.map { $1 })
                ) { content in
                    mediaCell(content)
                }
            }
            
            LazyVGrid(columns: [.init(.flexible())]) {
                ForEach(Array(store.media.enumerated()
                    .filter { !$0.offset.isMultiple(of: 2) }.map { $1 })
                ) { content in
                    mediaCell(content)
                }
            }
        }
    }
    
    private func mediaCell(_ content: ScrapMediaContentModel) -> some View {
        let playTime: TimeInterval? = {
            if case let .video(time) = content.contentType {
                return time
            } else {
                return nil
            }
        }()
        
        return MediaCell(
            imageURL: content.thumbnailURL,
            isSelected: false,
            playTime: playTime,
            date: content.datetime
        )
    }
    
    var emptyScrapView: some View {
        VStack(spacing: Self.emtpyViewSpacing) {
            Image(systemName: "xmark.bin")
                .resizable()
                .scaledToFit()
                .frame(width: Self.emtpyImageWidth)
            Text("스크랩된 미디어가 없습니다")
                .font(.body)
        }
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, Self.screenHeight / 3)
    }
}

// MARK: - View Constant
private extension ScrapView {
    static let pageSpacing: CGFloat = 16
    static let gridSpacing: CGFloat = 8
    static let emtpyViewSpacing: CGFloat = 20
    static let emtpyImageWidth: CGFloat = 50
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
