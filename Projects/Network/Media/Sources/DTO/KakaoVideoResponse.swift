//
//  KakaoVideoResponse.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

struct KakaoVideoResponse: Decodable {
    let meta: Meta
    let documents: [VideoDocument]
}

struct Meta: Decodable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
}

struct VideoDocument: Decodable {
    let title: String
    let url: String
    let datetime: String // ISO 8601 format
    let thumbnail: String
    let play_time: Int // seconds
    let author: String
    let description: String
}

