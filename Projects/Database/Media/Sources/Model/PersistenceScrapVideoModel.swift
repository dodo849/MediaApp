//
//  ScrapVideoModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class PersistenceScrapVideoModel: Object{
    @Persisted var id: ObjectId
    @Persisted var videoID: Int
    @Persisted var thumbnailURL: String
    @Persisted var videoURL: String
    @Persisted var datetime: Date
    
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
