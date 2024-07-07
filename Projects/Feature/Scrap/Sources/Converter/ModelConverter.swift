//
//  ModelConverter.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import CommonFeature
import MediaDatabase

struct ModelConverter {
    static func convert(
        _ persistenceImageModel: PersistenceScrapImageModel
    ) -> ScrapMediaContentModel {
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
    ) -> ScrapMediaContentModel {
        return .init(
            id: persistenceVideoModel.videoID,
            contentType: .video(playTime: persistenceVideoModel.playTime),
            thumbnailURL: persistenceVideoModel.thumbnailURL,
            contentURL: persistenceVideoModel.videoURL,
            datetime: persistenceVideoModel.datetime
        )
    }
}
