//
//  KakaoImageRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import CommonNetwork

import Alamofire

public struct KakaoImageRepository {
    private let requestURL = InfoConfig.baseURL + "\image"
    private let apiKey = InfoConfig.kakaoRestKey
    
    func searchImages(
        query: String,
        sort: String = "accuracy",
        page: Int = 1,
        size: Int = 80,
        completion: @escaping (Result<KakaoImageResponse, Error>) -> Void
    ) {
        assert((1...50).contains(page), "Page must be between 1 and 50")
        assert((1...80).contains(size), "Size must be between 1 and 80")
        
        let parameters: [String: Any] = [
            "query": query,
            "sort": sort,
            "page": page,
            "size": size
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        AF.request(
            requestURL,
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: KakaoImageResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
