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
    @Perception.Bindable var store: StoreOf<SearchFeature>
    
    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Search View")
                        .font(.headline)
                    TextField(
                        "검색어를 입력해주세요",
                        text: $store.searchKeyword.sending(\.searchKeywordChanged)
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: SearchView.gridSpacing),
                            GridItem(.flexible(), spacing: SearchView.gridSpacing)
                        ],
                        spacing: SearchView.gridSpacing
                    ) {
                        ForEach(store.media) {
                            KFImage(URL(string: $0.thumbnailUrl)!)
                                .fade(duration: 0.5)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(SearchView.gridSpacing)
            }
        }
    }
}

// MARK: - View Contant
extension SearchView {
    static let gridSpacing: CGFloat = 8
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
