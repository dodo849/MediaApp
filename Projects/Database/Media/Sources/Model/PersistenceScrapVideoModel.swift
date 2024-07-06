//
//  ScrapVideoModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class PersistenceScrapVideoModel: Object{
    @Persisted public var id: ObjectId
    @Persisted public var videoID: Int
    @Persisted public var thumbnailURL: String
    @Persisted public var videoURL: String
    @Persisted public var datetime: Date
    
    public convenience init(
        id: ObjectId = ObjectId.generate(),
        videoID: Int,
        thumbnailURL: String,
        videoURL: String,
        datetime: Date
    ) {
        self.init()
        self.id = id
        self.videoID = videoID
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.datetime = datetime
    }
}
