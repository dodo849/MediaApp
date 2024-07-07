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
        cache.memoryStorage.config.expiration = .seconds(60) // 5분
        
        // Limit memory cache size to 100 MB.
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100MB
        
        // Limit memory cache to hold 100 images at most.
        cache.memoryStorage.config.countLimit = 100
        
        // 디스크 캐시 만료 시간 설정
        cache.diskStorage.config.expiration = .days(7) // 7일
    }
}
