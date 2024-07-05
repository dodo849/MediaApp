//
//  ScrapView.swift
//  Scrap
//
//  Created by DOYEON LEE on 7/5/24.
//

import SwiftUI

import ComposableArchitecture

public struct ScrapView: View {
    @Perception.Bindable var store: StoreOf<ScrapFeature>
    
    public init(store: StoreOf<ScrapFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Button {
                store.send(.presentSearch)
            } label: {
                Text("Show SearchView")
            }
        }
    }
}
