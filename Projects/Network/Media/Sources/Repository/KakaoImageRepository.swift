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
    private static let maximumPage = 50
    private static let miximumSize = 80
    
    private let requestURL = "\(InfoConfig.baseURL.get)/image"
    private let apiKey = InfoConfig.kakaoRestKey.get
    
    public init() { }
    
    public func searchImages(
        query: String,
        sort: String = "recency",
        page: Int = 1,
        size: Int = 20
    ) async -> Result<KakaoImageResponse, KakaoAPIError> {
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
            .serializingDecodable(KakaoImageResponse.self)
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
private enum KakaoImageRepositoryDependencyKey: DependencyKey {
    static let liveValue: KakaoImageRepository = KakaoImageRepository()
}

public extension DependencyValues {
    var kakaoImageRepository: KakaoImageRepository {
        get { self[KakaoImageRepositoryDependencyKey.self] }
        set { self[KakaoImageRepositoryDependencyKey.self] = newValue }
    }
}
