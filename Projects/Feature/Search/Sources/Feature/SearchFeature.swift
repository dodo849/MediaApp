//
//  SearchFeature.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import MediaNetwork
import MediaDatabase

import ComposableArchitecture

@Reducer
public struct SearchFeature {
    // MARK: State
    @ObservableState
    public struct State: Equatable {
        public var searchKeyword: String = ""
        public var media: [SearchMediaContentModel] = []
        public var selectedContent: [SearchMediaContentModel] = []
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case searchKeywordChanged(String)
        case searchMedia
        case addMedia([SearchMediaContentModel])
        case selectContent(SearchMediaContentModel)
        case deselectContent(SearchMediaContentModel)
    }
    
    // MARK: Dependency
    let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "SearchFeature"
    )
    @Dependency(\.kakaoImageRepository) var kakaoImageRepository
    @Dependency(\.persistenceImageRepository) var persistenceImageRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .searchKeywordChanged(let text):
                state.searchKeyword = text
                print("text \(text)")
                return .send(.searchMedia)
                    .debounce(
                        id: DebounceID(),
                        for: 2,
                        scheduler: DispatchQueue.main
                    )
                
            case .searchMedia:
                let searchKeyword = state.searchKeyword
                return .run { send in
                    do {
                        let response = try await kakaoImageRepository
                            .searchImages(query: searchKeyword)
                        let mediaModels = MediaConverter
                            .convert(kakaoImageResponse: response)
                        await send(.addMedia(mediaModels))
                    } catch {
                        logger.error("\(error.localizedDescription)")
                    }
                }
                
            case .addMedia(let media):
                state.media.removeAll()
                state.media.append(contentsOf: media)
                return .none
                
            case .selectContent(let content):
                state.selectedContent.append(content)
                switch content.contentType {
                case .image:
                    let persistenceModel: PersistenceScrapImageModel = MediaConverter
                        .convert(content)
                    persistenceImageRepository.saveScrapImage(persistenceModel)
                case .video(let playTime):
                    break
                }
                
                return .none
                
            case .deselectContent(let content):
                state.selectedContent.removeAll(where: { $0.id == content.id })
                switch content.contentType {
                case .image:
                    persistenceImageRepository
                        .deleteScrapImage(byImageID: content.id)
                case .video(let playTime):
                    break
                }
                return .none
            }
        }
    }
    
    private struct DebounceID: Hashable {}
}
