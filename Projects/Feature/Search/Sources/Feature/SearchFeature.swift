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
        var searchKeyword: String = ""
        var media: [SearchMediaContentModel] = []
        var selectedContent: [SearchMediaContentModel] = []
        var lastPage: Int = 0
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action {
        case searchKeywordChanged(String)
        case searchMedia
        case loadMoreMedia
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
                state.media.removeAll()
                state.lastPage = 0
                return .send(.loadMoreMedia)
                
            case .loadMoreMedia:
                state.lastPage += 1
                let searchKeyword = state.searchKeyword
                let targetPage = state.lastPage
                print(targetPage)
                return .run { send in
                    do {
                        let mediaModels = try await fetchMediaContent(
                            query: searchKeyword,
                            page: targetPage
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
                }
                return .none
            }
        }
    }
    
    enum KakaoMediaFetchQueryKey: CacheQueryKey {
        case image(keyword: String, page: Int, size: Int)
        case video(keyword: String, page: Int, size: Int)
        
        static var expiry: TimeInterval { 60 * 5 }
    }
    
    func fetchMediaContent(
        query: String,
        page: Int
    ) async throws -> [SearchMediaContentModel] {
        print(page)
        let imageCacheQuery = CacheQuery.shared.makeQuery(
            key: KakaoMediaFetchQueryKey.image(
                keyword: query,
                page: page,
                size: 20
            ),
            expiry: KakaoMediaFetchQueryKey.expiry
        ) {
            try await kakaoImageRepository
                .searchImages(query: query, page: page)
        }
        
        let videoCacheQuery = CacheQuery.shared.makeQuery(
            key: KakaoMediaFetchQueryKey.video(
                keyword: query,
                page: page,
                size: 20
            ),
            expiry: KakaoMediaFetchQueryKey.expiry
        ) {
            try await kakaoVideoRepository
                .searchVideos(query: query, page: page)
        }
        
        // 병렬 처리
        async let imageResponse = imageCacheQuery()
        async let videoResponse = videoCacheQuery()
        
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
