//
//  KakaoImageRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import CommonNetwork

import Alamofire
import Dependencies

public struct KakaoImageRepository {
    private let requestURL = "\(InfoConfig.baseURL.get)/image"
    private let apiKey = InfoConfig.kakaoRestKey.get
    
    public init() { }
    
    public func searchImages(
        query: String,
        sort: String = "accuracy",
        page: Int = 1,
        size: Int = 10
    ) async throws -> KakaoImageResponse {
        assert((1...50).contains(page), "Page must be between 1 and 50")
        assert((1...80).contains(size), "Size must be between 1 and 80")
        
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
        .serializingDecodable(KakaoImageResponse.self).value
        
        return response
    }
}

// MARK: - Dependency
private enum KakaoImageRepositoryKey: DependencyKey {
    static let liveValue: KakaoImageRepository = KakaoImageRepository()
}

public extension DependencyValues {
  var kakaoImageRepository: KakaoImageRepository {
    get { self[KakaoImageRepositoryKey.self] }
    set { self[KakaoImageRepositoryKey.self] = newValue }
  }
}
