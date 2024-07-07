//
//  SearchView.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture
import Kingfisher

public struct SearchView: View {
    public typealias ViewAction = SearchFeature.ViewAction
    public typealias ViewState = SearchFeature.State
    
    @FocusState private var textFieldFocus: Bool
    
    @Perception.Bindable private var store: Store<ViewState, ViewAction>
    
    public init(store: StoreOf<SearchFeature>) {
        self.store = store.scope(
            state: \.self,
            action: \.view
        )
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBar(
                        text: $store.searchKeyword
                            .sending(\.searchKeywordChanged)
                    )
                    .focused($textFieldFocus)
                    
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
                                isSelected: store.selectedContent.contains(content),
                                playTime: playTime,
                                date: content.datetime
                            ).onTapGesture {
                                if store.selectedContent.contains(content) {
                                    store.send(.deselectContent(content))
                                } else {
                                    store.send(.selectContent(content))
                                }
                            }
                            .onAppear {
                                if content == store.media.last {
                                    store.send(.loadMoreMedia)
                                }
                            }
                        }
                    }
                }
                .padding(Self.gridSpacing)
                .onAppear {
                    textFieldFocus = true
                }
            }
        }
    }
}

// MARK: - View Contant
extension SearchView {
    static let gridSpacing: CGFloat = 8
    static let imageRadius: CGFloat = 4
}

// MARK: - Preview
#Preview {
    SearchView(
        store: Store(
            initialState:
                SearchFeature.State()
        ) {
            SearchFeature()
        }
    )
}
