//
//  KakaoVideoResponse.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct KakaoVideoResponse: Decodable {
    public let meta: Meta
    public let documents: [VideoDocument]
    
    public struct Meta: Decodable {
        public let total_count: Int
        public let pageable_count: Int
        public let is_end: Bool
    }

    public struct VideoDocument: Decodable {
        public let title: String
        public let url: String
        public let datetime: String // ISO 8601 format
        public let play_time: Int // seconds
        public let thumbnail: String
        public let author: String
    }
}
