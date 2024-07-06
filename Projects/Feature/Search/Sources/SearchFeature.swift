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
        public var images: [KakaoImageResponse.Document] = []
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case searchKeywordChanged(String)
        case searchMedia
        case addMedia([KakaoImageResponse.Document])
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
                return .send(.searchMedia)
                    .debounce(id: DebounceID(), for: 2, scheduler: DispatchQueue.main)
                
            case .searchMedia:
                let searchKeyword = state.searchKeyword
                return .run { send in
                    do {
                        let response = try await kakaoImageRepository
                            .searchImages(query: searchKeyword)
                        await send(.addMedia(response.documents))
                    } catch {
                        logger.error("\(error.localizedDescription)")
                    }
                }
                
            case .addMedia(let media):
                state.images.removeAll()
                state.images.append(contentsOf: media)
                return .none
            }
        }
    }
    
    private struct DebounceID: Hashable {}
}
