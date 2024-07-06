//
//  SearchFeature.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import MediaNetwork

import ComposableArchitecture

@Reducer
public struct SearchFeature {
    // MARK: State
    @ObservableState
    public struct State: Equatable {
        public var searchKeyword: String = ""
        public var media: [MediaModel] = []
        public var selectedContent: [MediaModel] = []
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case searchKeywordChanged(String)
        case searchMedia
        case addMedia([MediaModel])
        case selectContent(MediaModel)
        case deselectContent(MediaModel)
    }
    
    // MARK: Dependency
    let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "SearchFeature"
    )
    @Dependency(\.kakaoImageRepository) var kakaoImageRepository
    
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
                return .none
                
            case .deselectContent(let content):
                state.selectedContent.removeAll(where: { $0.id == content.id })
                return .none
            }
        }
    }
    
    private struct DebounceID: Hashable {}
}
