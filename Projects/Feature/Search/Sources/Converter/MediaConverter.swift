//
//  MediaConverter.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import MediaNetwork

struct MediaConverter {
    static func convert(kakaoImageResponse: KakaoImageResponse) -> [MediaModel] {
        return kakaoImageResponse.documents.map {
            MediaModel(
                mediaType: .image,
                thumbnailUrl: $0.thumbnail_url
            )
        }
    }
}
