//
//  KakaoVideoRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import CommonNetwork

import Alamofire

struct KakaoVideoRepository {
    private let requestURL = InfoConfig.baseURL + "\vclip"
    private let apiKey = InfoConfig.kakaoRestKey
    
    // 동영상 검색 요청을 보내는 함수
    func searchVideos(
        query: String,
        sort: String = "accuracy",
        page: Int? =  1,
        size: Int? = 10,
        completion: @escaping (Result<KakaoVideoResponse, Error>) -> Void
    ) {
        assert((1...15).contains(page), "Page must be between 1 and 15")
        assert((1...30).contains(size), "Size must be between 1 and 30")
        
        let parameters: [String: Any] = [
            "query": query,
            "sort": sort
            "page": page
            "size": size
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        AF.request(baseURL, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: KakaoVideoResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
