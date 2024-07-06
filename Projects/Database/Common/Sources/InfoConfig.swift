//
//  InfoConfig.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

public enum InfoConfig {
    case baseURL, kakaoRestKey
    
    var get: String {
        switch self {
        case .baseURL:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URLL") as? String
            else { fatalError("API_BASE_URL is not set in Info.plist") }
            return url
        case .kakaoRestKey:
            guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String
            else { fatalError("KAKAO_REST_API_KEY is not set in Info.plist") }
            return key
        }
    }
}
