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
                    Text("Search")
                        .font(.headline)
                    TextField(
                        "검색어를 입력해주세요",
                        text: $store.searchKeyword.sending(\.searchKeywordChanged)
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Self.gridSpacing),
                            GridItem(.flexible(), spacing: Self.gridSpacing)
                        ],
                        spacing: Self.gridSpacing
                    ) {
                        ForEach(store.media) { content in
                            ZStack {
                                KFImage(URL(string: content.thumbnailURL)!)
                                    .fade(duration: 0.5)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(Self.imageRadius)
                                    .onTapGesture {
                                        if store.selectedContent.contains(content) {
                                            store.send(.deselectContent(content))
                                        } else {
                                            store.send(.selectContent(content))
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Self.imageRadius)
                                            .stroke(
                                                store.selectedContent.contains(content)
                                                ? Color.blue
                                                : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                
                                datatimeOverlay(content.datetime)
                                
                                if store.selectedContent.contains(content) {
                                    checkedImageOverlay
                                }
                            }
                        }
                    }
                }
                .padding(Self.gridSpacing)
            }
        }
    }
    
    private var checkedImageOverlay: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "archivebox.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
        }
        .padding(SearchView.gridSpacing)
    }
    
    private func datatimeOverlay(_ date: Date) -> some View {
        VStack {
            Spacer()
            HStack {
                Text(date, format: .dateTime)
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(8)
                    .background(.thinMaterial)
                    .clipShape(.capsule)
                Spacer()
            }
        }
        .padding(Self.gridSpacing)
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
