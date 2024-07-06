//
//  ScrapFeature.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import Foundation

import SearchFeature
import MediaDatabase

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
        public var media: [ScrapMediaContentModel] = []
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case onAppear
        case presentSearchView
        case destination(PresentationAction<Destination.Action>)
        case addMedia([ScrapMediaContentModel])
    }
    
    // MARK: Dependency
    @Dependency(\.persistenceImageRepository) var persistenceImageRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let persistenceImageModels = persistenceImageRepository
                        .getAllScrapImage()
                    let mediaContentModels = Array(persistenceImageModels)
                        .map { ModelConverter.convert($0) }
                    await send(.addMedia(mediaContentModels))
                }
                
            case .presentSearchView:
                state.destination = .search(.init())
                return .none
                
            case .destination(.dismiss):
                state.destination = nil
                return .none
                
            case .destination(.presented(_)):
                return .none
                
            case .addMedia(let media):
                state.media.append(contentsOf: media)
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
