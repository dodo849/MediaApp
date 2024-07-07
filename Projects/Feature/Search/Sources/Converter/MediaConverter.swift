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
    // MARK: Netowrk model to Feature model
    static func convert(
        _ kakaoImageResponse: KakaoImageResponse
    ) -> [SearchMediaContentModel] {
        return kakaoImageResponse.documents.map {
            .init(
                contentType: .image,
                thumbnailURL: $0.thumbnail_url,
                contentURL: $0.image_url,
                datetime: $0.datetime.toDate() ?? Date()
            )
        }
    }
    
    static func convert(
        _ kakaoVideoResponse: KakaoVideoResponse
    ) -> [SearchMediaContentModel] {
        return kakaoVideoResponse.documents.map {
            .init(
                contentType: .video(playTime: TimeInterval($0.play_time)),
                thumbnailURL: $0.thumbnail,
                contentURL: $0.url,
                datetime: $0.datetime.toDate() ?? Date()
            )
        }
    }
    
    // MARK: Feature model to Persistence model
    static func convert(
        _ mediaContent: SearchMediaContentModel
    ) -> PersistenceScrapImageModel {
        guard case .image = mediaContent.contentType else {
            fatalError("Expected contentType to be .image")
        }
        return .init(
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
        return .init(
            videoID: mediaContent.id,
            thumbnailURL: mediaContent.thumbnailURL,
            videoURL: mediaContent.contentURL,
            playTime: playTime,
            datetime: mediaContent.datetime
        )
    }
    
    // MARK: Persistence model to Feature model
    static func convert(
        _ persistenceImageModel: PersistenceScrapImageModel
    ) -> SearchMediaContentModel {
        return .init(
            id: persistenceImageModel.imageID,
            contentType: .image,
            thumbnailURL: persistenceImageModel.thumbnailURL,
            contentURL: persistenceImageModel.imageURL,
            datetime: persistenceImageModel.datetime
        )
    }
    
    static func convert(
        _ persistenceVideoModel: PersistenceScrapVideoModel
    ) -> SearchMediaContentModel {
        return .init(
            id: persistenceVideoModel.videoID,
            contentType: .video(playTime: persistenceVideoModel.playTime),
            thumbnailURL: persistenceVideoModel.thumbnailURL,
            contentURL: persistenceVideoModel.videoURL,
            datetime: persistenceVideoModel.datetime
        )
    }
}
