//
//  KingfisherConfig.swift
//  MediaApp
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import Kingfisher

struct KingfisherConfig {
    static func setup() {
        // 캐시 설정
        let cache = ImageCache.default
        // 메모리 캐시 만료 시간 설정
        cache.memoryStorage.config.expiration = .seconds(60 * 60) // 1시간 60 * 60
        // 디스크 캐시 만료 시간 설정
        cache.diskStorage.config.expiration = .days(7) // 7일
    }
}
