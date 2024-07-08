//
//  ScrapFeature.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/5/24.
//

import Foundation
import OSLog

import CommonFeature
import SearchFeature
import MediaDatabase

import ComposableArchitecture
import Kingfisher

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
    public enum Action: FeatureAction {
        case view(ViewAction)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @CasePathable
    public enum ViewAction {
        case onAppear
        case presentSearchView
    }
    
    public enum InnerAction: Equatable {
        case addMedia([ScrapMediaContentModel])
    }
    
    public enum AsyncAction: Equatable {}
    public enum ScopeAction: Equatable { }
    public enum DelegateAction: Equatable { }
    
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
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return .run { send in
                        do {
                            let mediaContentModels = try await fetchScrapContent()
                            await send(.inner(.addMedia(mediaContentModels)))
                        } catch {
                            self.logger
                                .error("Failed to fetch image info: \(error.localizedDescription)")
                        }
                    }
                    
                case .presentSearchView:
                    state.destination = .search(.init())
                    return .none
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .addMedia(let media):
                    state.media.removeAll()
                    state.media.append(contentsOf: media)
                    return .none
                }
                
            case .destination(.dismiss):
                KingfisherManager.shared.cache.clearCache()
                state.destination = nil
                return .none
                
            case .destination(.presented):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    /// 내부 DB에서 스크랩된 컨텐츠를 불러옵니다.
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
