//
//  SearchFeature.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import ComposableArchitecture

@Reducer
public struct SearchFeature {
    @ObservableState
    public struct State: Equatable {
        
        public init() { }
    }
    
    public enum Action {
    }
    
    // MARK: Dependency
    
    // MARK: Initializer
    public init() { }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
