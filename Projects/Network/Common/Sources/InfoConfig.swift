//
//  InfoConfig.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

public enum InfoConfig {
    case baseURL
    case kakaoRestKey
    
    public var get: String {
        switch self {
        case .baseURL:
            guard let url = Bundle.module.object(forInfoDictionaryKey: "API_BASE_URL") as? String
            else { fatalError("API_BASE_URL is not set in Info.plist") }
            return url
        case .kakaoRestKey:
            guard let key = Bundle.module.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String
            else { fatalError("KAKAO_REST_API_KEY is not set in Info.plist") }
            return key
        }
    }
}
