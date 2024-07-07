//
//  KakaoVideoRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import CommonNetwork

import Alamofire
import Dependencies

public struct KakaoVideoRepository {
    private let requestURL = "\(InfoConfig.baseURL.get)/vclip"
    private let apiKey = InfoConfig.kakaoRestKey.get
    
    public init() { }
    
    public func searchVideos(
        query: String,
        sort: String = "recency",
        page: Int = 1,
        size: Int = 20
    ) async throws -> KakaoVideoResponse {
        // TODO: Last page 확인 절차 필요
        assert((1...15).contains(page), "Page must be between 1 and 15")
        assert((1...30).contains(size), "Size must be between 1 and 30")
        
        let parameters: [String: Any] = [
            "query": query,
            "sort": sort,
            "page": page,
            "size": size
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        let response = try await AF.request(
            requestURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            headers: headers
        )
        .validate()
        .serializingDecodable(KakaoVideoResponse.self).value
        
        return response
    }
}

// MARK: - Dependency
private enum KakaoVideoRepositoryKey: DependencyKey {
    static let liveValue: KakaoVideoRepository = KakaoVideoRepository()
}

public extension DependencyValues {
  var kakaoVideoRepository: KakaoVideoRepository {
    get { self[KakaoVideoRepositoryKey.self] }
    set { self[KakaoVideoRepositoryKey.self] = newValue }
  }
}
