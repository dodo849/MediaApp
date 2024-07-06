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
    @Dependency(\.persistenceVideoRepository) var persistenceVideoRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let mediaContentModels = try await fetchScrapContent()
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
    
    func fetchScrapContent() async throws -> [ScrapMediaContentModel] {
        async let persistenceImages = persistenceImageRepository
            .getAllScrapImage()
        async let persistenceVideos = persistenceVideoRepository
            .getAllScrapVideo()
        
        let (images, videos) = try await (persistenceImages, persistenceVideos)
        
        let imageModels = images.map {
            ModelConverter.convert($0)
        }
        let videoModels = videos.map {
            ModelConverter.convert($0)
        }
        
        let mergedModels = imageModels + videoModels
        let sortedModels = mergedModels
            .sorted { $0.datetime > $1.datetime }
        
        return sortedModels
    }
}
