//
//  ScrapFeature.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct ScrapFeature {
    @ObservableState
    public struct State: Equatable {
        
        public init() { }
    }
    
    public enum Action {
        case presentSearch
    }
    
    // MARK: Dependency
    
    // MARK: Initializer
    public init() { }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .presentSearch:
                return .none
            }
        }
    }
}
