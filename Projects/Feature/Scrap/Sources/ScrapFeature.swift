//
//  ScrapFeature.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import Foundation

import SearchFeature
import MediaNetwork

import ComposableArchitecture

@Reducer
public struct ScrapFeature {
    // MARK: Navigation
    @Reducer
    public enum Destination {
        case search(SearchFeature)
    }
    
    // MARK: State
    @ObservableState
    public struct State {
        @Presents public var destination: Destination.State?
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case onAppear
        case presentSearchView
        case destination(PresentationAction<Destination.Action>)
    }
    
    // MARK: Dependency
    @Dependency(\.kakaoImageRepository) var kakaoImageRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .presentSearchView:
                state.destination = .search(.init())
                return .none
            case .destination(.dismiss):
                state.destination = nil
                return .none
            case .destination(.presented(_)):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
