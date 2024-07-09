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
    private static let maximumPage = 15
    private static let miximumSize = 30
    
    private let requestURL = "\(InfoConfig.baseURL.get)/vclip"
    private let apiKey = InfoConfig.kakaoRestKey.get
    
    public init() { }
    
    public func searchVideos(
        query: String,
        sort: String = "recency",
        page: Int = 1,
        size: Int = 20
    ) async -> Result<KakaoVideoResponse, KakaoAPIError> {
        if page > Self.maximumPage {
            return .failure(.pageOverflow)
        }
        
        assert((1...Self.maximumPage).contains(page), "Page must be between 1 and \(Self.maximumPage)")
        assert((1...Self.miximumSize).contains(size), "Size must be between 1 and \(Self.miximumSize)")
        
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
        
        let response = await AF.request(
            requestURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            headers: headers
        )
        .validate()
        .serializingDecodable(KakaoVideoResponse.self)
        .response
        
        switch response.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            if let httpStatusCode = response.response?.statusCode,
                httpStatusCode == 400 {
                return .failure(.badRequest)
            } else {
                return .failure(.unknowned(error))
            }
        }
    }
}

// MARK: - Dependency
private enum KakaoVideoRepositoryDependencyKey: DependencyKey {
    static let liveValue: KakaoVideoRepository = KakaoVideoRepository()
}

public extension DependencyValues {
  var kakaoVideoRepository: KakaoVideoRepository {
    get { self[KakaoVideoRepositoryDependencyKey.self] }
    set { self[KakaoVideoRepositoryDependencyKey.self] = newValue }
  }
}
