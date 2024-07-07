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
        cache.memoryStorage.config.expiration = .seconds(60 * 5) // 5분
        
        // 메모리 캐시 전체 용량 제한 100 MB.
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100MB
        
        // 메모리 캐시 이미지 개수 제한
        cache.memoryStorage.config.countLimit = 100 // 100개
        
        // 디스크 캐시 만료 시간 설정
        cache.diskStorage.config.expiration = .days(7) // 7일
    }
}
