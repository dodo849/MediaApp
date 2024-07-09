//
//  KakaoImageResponse.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct KakaoImageResponse: Codable {
    public let meta: Meta
    public let documents: [Document]
    
    public struct Meta: Codable {
        public let total_count: Int
        public let pageable_count: Int
        public let is_end: Bool
    }

    public struct Document: Codable {
        public let collection: String
        public let thumbnail_url: String
        public let image_url: String
        public let width: Int
        public let height: Int
        public let display_sitename: String
        public let doc_url: String
        public let datetime: String // ISO 8601 format
    }
}
