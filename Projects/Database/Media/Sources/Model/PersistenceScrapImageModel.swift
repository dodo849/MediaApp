//
//  ScrapImageModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class PersistenceScrapImageModel: Object {
    @Persisted public var id: ObjectId
    @Persisted public var imageID: String
    @Persisted public var thumbnailURL: String
    @Persisted public var imageURL: String
    @Persisted public var datetime: Date
    
    public convenience init(
        id: ObjectId = ObjectId.generate(),
        imageID: String,
        thumbnailURL: String,
        imageURL: String,
        datetime: Date
    ) {
        self.init()
        self.id = id
        self.imageID = imageID
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.datetime = datetime
    }
}
