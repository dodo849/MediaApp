//
//  ScrapFeature.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import Foundation
import OSLog

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
    let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "ScrapFeature"
    )
    @Dependency(\.persistenceImageRepository) var persistenceImageRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let persistenceImageModels = try await persistenceImageRepository
                            .getAllScrapImage()
                        let mediaContentModels = persistenceImageModels
                            .map { ModelConverter.convert($0) }
                        await send(.addMedia(mediaContentModels))
                    } catch {
                        self.logger.error("Failed to fetch image info: \(error.localizedDescription)")
                    }
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
                state.media.removeAll()
                state.media.append(contentsOf: media)
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
