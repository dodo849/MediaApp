//
//  SearchView.swift
//  Scrap
//
//  Created by DOYEON LEE on 7/5/24.
//

import SwiftUI

import ComposableArchitecture

public struct SearchView: View {
    @Perception.Bindable var store: StoreOf<SearchFeature>
    
    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("Search View")
                TextField(
                    "검색어를 입력해주세요",
                    text: $store.searchKeyword.sending(\.searchKeywordChanged)
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("text \(store.images)")
            }
        }
    }
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchFeature.State()) {
                SearchFeature()
            }
    )
}
