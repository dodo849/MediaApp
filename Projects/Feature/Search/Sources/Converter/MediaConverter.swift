//
//  MediaConverter.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import CommonFeature
import MediaNetwork
import MediaDatabase

struct ModelConverter {
    static func convert(
        kakaoImageResponse: KakaoImageResponse
    ) -> [SearchMediaContentModel] {
        return kakaoImageResponse.documents.map {
            SearchMediaContentModel(
                contentType: .image,
                thumbnailURL: $0.thumbnail_url,
                contentURL: $0.image_url,
                datetime: $0.datetime.toDate() ?? Date()
            )
        }
    }
    
    static func convert(
        kakaoVideoResponse: KakaoVideoResponse
    ) -> [SearchMediaContentModel] {
        return kakaoVideoResponse.documents.map {
            SearchMediaContentModel(
                contentType: .video(playTime: $0.play_time),
                thumbnailURL: $0.thumbnail,
                contentURL: $0.url,
                datetime: $0.datetime.toDate() ?? Date()
            )
        }
    }
    
    static func convert(
        _ mediaContent: SearchMediaContentModel
    ) -> PersistenceScrapImageModel {
        guard case .image = mediaContent.contentType else {
            fatalError("Expected contentType to be .image")
        }
        return PersistenceScrapImageModel(
            imageID: mediaContent.id,
            thumbnailURL: mediaContent.thumbnailURL,
            imageURL: mediaContent.contentURL,
            datetime: mediaContent.datetime
        )
    }
    
    static func convert(
        _ mediaContent: SearchMediaContentModel
    ) -> PersistenceScrapVideoModel {
        guard case .video(let playTime) = mediaContent.contentType else {
            fatalError("Expected contentType to be .video")
        }
        return PersistenceScrapVideoModel(
            videoID: mediaContent.id,
            thumbnailURL: mediaContent.thumbnailURL,
            videoURL: mediaContent.contentURL,
            datetime: mediaContent.datetime
        )
    }
}
