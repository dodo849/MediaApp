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
        Text("Search")
    }
}
