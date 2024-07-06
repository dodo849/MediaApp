//
//  ScrapVideoModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class ScrapVideoModel: Object {
    @Persisted var id: ObjectId
    @Persisted var collection: String
    @Persisted var thumbnailURL: String
    @Persisted var videoURL: String
    @Persisted var datetime: Date
    
    public convenience init(
        id: ObjectId = ObjectId.generate(),
        collection: String,
        thumbnailURL: String,
        videoURL: String,
        datetime: Date
    ) {
        self.init()
        self.id = id
        self.collection = collection
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.datetime = datetime
    }
}
