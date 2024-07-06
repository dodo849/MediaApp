//
//  SearchFeature.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import CacheCore
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
        case selectContents([SearchMediaContentModel])
        case deselectContent(SearchMediaContentModel)
    }
    
    // MARK: Dependency
    let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "SearchFeature"
    )
    @Dependency(\.kakaoImageRepository) var kakaoImageRepository
    @Dependency(\.kakaoVideoRepository) var kakaoVideoRepository
    @Dependency(\.persistenceImageRepository) var persistenceImageRepository
    @Dependency(\.persistenceVideoRepository) var persistenceVideoRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .searchKeywordChanged(let text):
                state.searchKeyword = text
                return .send(.searchMedia)
                    .debounce(
                        id: DebounceID(),
                        for: 1.5,
                        scheduler: DispatchQueue.main
                    )
                
            case .searchMedia:
                let searchKeyword = state.searchKeyword
                return .run { send in
                    do {
                        let mediaModels = try await fetchMediaContent(
                            query: searchKeyword
                        )
                        await send(.addMedia(mediaModels))
                        
                        let scrapedContents = try await compareIsScrapped(
                            searchContents: mediaModels
                        )
                        await send(.selectContents(scrapedContents))
                        
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
                return .run { _ in
                    switch content.contentType {
                    case .image:
                        let persistenceModel: PersistenceScrapImageModel = ModelConverter
                            .convert(content)
                        persistenceImageRepository.saveScrapImage(persistenceModel)
                    case .video:
                        let persistenceModel: PersistenceScrapVideoModel = ModelConverter
                            .convert(content)
                        persistenceVideoRepository.saveScrapVideo(persistenceModel)
                    }
                }
                
            case .selectContents(let contents):
                state.selectedContent.append(contentsOf: contents)
                return .none
                
            case .deselectContent(let content):
                state.selectedContent.removeAll(where: { $0.id == content.id })
                switch content.contentType {
                case .image:
                    persistenceImageRepository
                        .deleteScrapImage(byImageID: content.id)
                case .video:
                    persistenceVideoRepository
                        .deleteScrapVideo(byVideoID: content.id)
                    break
                }
                return .none
            }
        }
    }
    
    enum KakaoMediaFetchQueryKey: CacheQueryKey {
        case image(keyword: String, page: Int, size: Int)
        case video(keyword: String, page: Int, size: Int)
    }
    
    func fetchMediaContent(
        query: String
    ) async throws -> [SearchMediaContentModel] {
        let imageCachequery = CacheQuery.makeQuery(
            key: KakaoMediaFetchQueryKey.image(
                keyword: query,
                page: 1,
                size: 10
            ),
            expiry: 60 * 1
        ) {
            try await kakaoImageRepository
                .searchImages(query: query)
        }
        
        async let imageResponse = imageCachequery()
        async let videoResponse = kakaoVideoRepository.searchVideos(query: query)
        
        let (images, videos) = try await (imageResponse, videoResponse)
        
        let imageModels = ModelConverter.convert(images)
        let videoModels = ModelConverter.convert(videos)
        
        let mergedModels = imageModels + videoModels
        let sortedModels = mergedModels
            .sorted { $0.datetime > $1.datetime }
        
        return sortedModels
    }
    
    func compareIsScrapped(
        searchContents: [SearchMediaContentModel]
    ) async throws -> [SearchMediaContentModel] {
        // Fetch all scraped images and videos
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
        
        // Compare search contents with scraped images and videos using id
        let searchContentIds = searchContents.map { $0.id }
        let scrappedContents = mergedModels
            .filter { searchContentIds.contains($0.id) }
        
        return scrappedContents
    }
    
    private struct DebounceID: Hashable {}
}
