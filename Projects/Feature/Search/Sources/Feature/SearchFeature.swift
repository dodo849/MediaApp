//
//  SearchFeature.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import CommonFeature
import CacheCore
import MediaNetwork
import MediaDatabase

import ComposableArchitecture
import Kingfisher

@Reducer
public struct SearchFeature {
    // MARK: State
    @ObservableState
    public struct State: Equatable {
        /// 검색 키워드
        var searchKeyword: String = ""
        /// 검색된 미디어(이미지 & 동영상)
        var media: [SearchMediaContentModel] = []
        /// 선택된(스크랩된 미디어)
        var selectedContent: [SearchMediaContentModel] = []
        /// 이미지 검색 페이지 정보
        var imagePaging: Paging = Paging()
        /// 동영상 검색 페이지 정보
        var videoPaging: Paging = Paging()
        
        struct Paging: Equatable { // TODO: Paging 로직을 어디에 둘지 고민
            /// 현재 키워드로 조회한 마지막 페이지
            var page: Int = 1
            /// 마지막 페이지 여부
            var isLastPage: Bool = false
        }
        
        public init() { }
    }
    
    // MARK: Action
    public enum Action: FeatureAction {
        case view(ViewAction)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    @CasePathable
    public enum ViewAction {
        case searchKeywordChanged(String)
        case selectContent(SearchMediaContentModel)
        case deselectContent(SearchMediaContentModel)
        case loadMoreMedia
    }
    
    public enum InnerAction {
        case searchMedia(String)
        case imagePageIsLast
        case videoPageIsLast
        case addMedia([SearchMediaContentModel])
        case selectContents([SearchMediaContentModel])
    }
    
    @CasePathable
    public enum AsyncAction {
        case mediaResponse(Result<[SearchMediaContentModel], Error>)
    }
    
    public enum ScopeAction: Equatable { }
    public enum DelegateAction: Equatable { }
    
    // MARK: Dependency
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "SearchFeature"
    )
    @Dependency(\.cacheQuery) private var cacheQuery
    @Dependency(\.kakaoImageRepository) private var kakaoImageRepository
    @Dependency(\.kakaoVideoRepository) private var kakaoVideoRepository
    @Dependency(\.persistenceImageRepository) private var persistenceImageRepository
    @Dependency(\.persistenceVideoRepository) private var persistenceVideoRepository
    
    // MARK: Initializer
    public init() { }
    
    // MARK: Body
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .searchKeywordChanged(let text):
                    state.searchKeyword = text
                    
                    state.media.removeAll()
                    state.imagePaging = .init()
                    state.videoPaging = .init()
                    
                    if text.isEmpty {
                        return .none
                    } else {
                        return .send(.inner(.searchMedia(text)))
                            .debounce(
                                id: DebounceID(),
                                for: 0.3,
                                scheduler: DispatchQueue.main
                            )
                    }
                    
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
                    
                case .loadMoreMedia:
                    let keyword = state.searchKeyword
                    return .send(.inner(.searchMedia(keyword)))
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .searchMedia(let keyword):
                    let imagePaging = state.imagePaging
                    let videoPaging = state.videoPaging
                    
                    return .run { send in
                        do {
                            /// 이미지 및 동영상 요청
                            async let fetchImages = fetchImageContents(
                                keyword: keyword,
                                page: imagePaging.page,
                                isLastPage: imagePaging.isLastPage
                            )
                            async let fetchVideos = fetchVideoContents(
                                keyword: keyword,
                                page: videoPaging.page,
                                isLastPage: videoPaging.isLastPage
                            )
                            
                            let (imageResult, videoResult) = try await (fetchImages, fetchVideos)
                            
                            await send(.async(.mediaResponse(imageResult)))
                            await send(.async(.mediaResponse(videoResult)))
                            
                        } catch {
                            logger.error("\(error.localizedDescription)")
                        }
                    }
                    
                case .imagePageIsLast:
                    state.imagePaging.isLastPage = true
                    return .none
                    
                case .videoPageIsLast:
                    state.videoPaging.isLastPage = true
                    return .none
                    
                case .addMedia(let media):
                    state.media.append(contentsOf: media.sorted { $0.datetime > $1.datetime })
                    state.media = state.media.sorted { $0.datetime > $1.datetime }
                    return .none
                    
                case .selectContents(let contents):
                    state.selectedContent.append(contentsOf: contents)
                    return .none
                }
                
            case .async(let asyncAction):
                switch asyncAction {
                case let .mediaResponse(.success(contents)):
                    if let firstContent = contents.first {
                        switch firstContent.contentType {
                        case .image:
                            state.imagePaging.page += 1
                        case .video:
                            state.videoPaging.page += 1
                        }
                    }
                    
                    return .run { send in
                        /// 스크랩 여부 확인
                        let scrapedContents = try await compareIsScrapped(
                            searchContents: contents
                        )
                        
                        await send(.inner(.addMedia(contents)))
                        await send(.inner(.selectContents(scrapedContents)))
                        
                    }

                case let .mediaResponse(.failure(error)):
                    logger.error("\(error.localizedDescription)")
                    return .none
                }
            }
        }
    }
    
    /// Kakao API를 이용해 이미지 데이터를 요청합니다.
    private func fetchImageContents(
        keyword: String,
        page: Int,
        isLastPage: Bool
    ) async throws -> Result<[SearchMediaContentModel], Error> {
        // CacheQuery를 이용해 서버데이터 캐싱
        let imageCacheQuery = cacheQuery.makeQuery(
            key: KakaoMediaFetchQueryKey.image(
                keyword: keyword,
                page: page,
                size: 20
            ),
            expiry: KakaoMediaFetchQueryKey.expiry
        ) { () async -> Result<[SearchMediaContentModel], Error> in
            let result = await kakaoImageRepository
                .searchImages(query: keyword, page: page)
            
            switch result {
            case let .success(response):
                let convertedModels = ModelConverter.convert(response)
                return .success(convertedModels)
                
            case let .failure(error):
                return .failure(error)
            }
        }
        
        do {
            return try await imageCacheQuery()
        } catch {
            return .failure(error)
        }
    }
    
    /// Kakao API를 이용해 동영상 데이터를 요청합니다.
    private func fetchVideoContents(
        keyword: String,
        page: Int,
        isLastPage: Bool
    ) async -> Result<[SearchMediaContentModel], Error> {
        // CacheQuery를 이용해 서버데이터 캐싱
        let videoCacheQuery = cacheQuery.makeQuery(
            key: KakaoMediaFetchQueryKey.video(
                keyword: keyword,
                page: page,
                size: 20
            ),
            expiry: KakaoMediaFetchQueryKey.expiry
        ) { () async -> Result<[SearchMediaContentModel], Error> in
            let result = await kakaoVideoRepository
                .searchVideos(query: keyword, page: page)
            
            switch result {
            case let .success(response):
                let convertedModels = ModelConverter.convert(response)
                return .success(convertedModels)
                
            case let .failure(error):
                return .failure(error)
            }
        }
        
        do { // Handle CacheQuery error
            return try await videoCacheQuery()
        } catch {
            return .failure(error)
        }
    }
    
    /// 검색 결과 중 스크랩된 요소를 반환합니다.
    private func compareIsScrapped(
        searchContents: [SearchMediaContentModel]
    ) async throws -> [SearchMediaContentModel] {
        // 스크랩된 모든 비디오, 이미지 가져오기
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
        
        // 검색 결과와 비교해 스크랩된 미디어가 있는지 확인
        let searchContentIds = searchContents.map { $0.id }
        let scrappedContents = mergedModels
            .filter { searchContentIds.contains($0.id) }
        
        return scrappedContents
    }
}

// MARK: - Dependency
private enum KakaoMediaFetchQueryDependencyKey: DependencyKey {
    static let liveValue: CacheQuery<KakaoMediaFetchQueryKey> = CacheQuery<KakaoMediaFetchQueryKey>()
}

private extension DependencyValues {
    var cacheQuery: CacheQuery<KakaoMediaFetchQueryKey> {
        get { self[KakaoMediaFetchQueryDependencyKey.self] }
        set { self[KakaoMediaFetchQueryDependencyKey.self] = newValue }
    }
}

// MARK: - Private type
private struct DebounceID: Hashable {}

private enum KakaoMediaFetchQueryKey: CacheQueryKey {
    case image(keyword: String, page: Int, size: Int)
    case video(keyword: String, page: Int, size: Int)
    
    static var expiry: TimeInterval { 60 * 5 }
}

private enum KakaoMediaFetchError: Error {
    case isLastImagePage
    case isLastVideoPage
}
