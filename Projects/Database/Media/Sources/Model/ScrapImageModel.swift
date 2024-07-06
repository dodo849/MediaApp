//
//  ScrapImageModel.swift
//  MediaDatabase
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

import RealmSwift

public class ScrapImageModel: Object {
    @Persisted var id: ObjectId
    @Persisted var collection: String
    @Persisted var thumbnailURL: String
    @Persisted var imageURL: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var displaySitename: String
    @Persisted var docURL: String
    @Persisted var datetime: Date
    
    public convenience init(
        id: ObjectId = ObjectId.generate(),
        collection: String,
        thumbnailURL: String,
        imageURL: String,
        width: Int,
        height: Int,
        displaySitename: String,
        docURL: String,
        datetime: Date
    ) {
        self.init()
        self.id = id
        self.collection = collection
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.displaySitename = displaySitename
        self.docURL = docURL
        self.datetime = datetime
    }
}
