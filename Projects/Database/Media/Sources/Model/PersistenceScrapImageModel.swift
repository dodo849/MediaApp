//
//  ScrapImageModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class PersistenceScrapImageModel: Object {
    @Persisted var id: ObjectId
    @Persisted var imageID: Int
    @Persisted var thumbnailURL: String
    @Persisted var imageURL: String
    @Persisted var datetime: Date
    
    public convenience init(
        id: ObjectId = ObjectId.generate(),
        imageID: Int,
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
