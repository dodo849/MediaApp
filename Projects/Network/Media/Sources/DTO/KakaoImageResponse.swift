//
//  KakaoImageResponse.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct KakaoImageResponse: Decodable {
    let meta: Meta
    let documents: [Document]
    
    public struct Meta: Decodable {
        let total_count: Int
        let pageable_count: Int
        let is_end: Bool
    }

    public struct Document: Decodable {
        let collection: String
        let thumbnail_url: String
        let image_url: String
        let width: Int
        let height: Int
        let display_sitename: String
        let doc_url: String
        let datetime: String // ISO 8601 format
    }
}
