//
//  ScrapMediaContentModel.swift
//  ScrapFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct ScrapMediaContentModel: Equatable, Identifiable {
    public let id: Int
    public let contentType: MediaType
    public let thumbnailURL: String
    public let contentURL: String
    public var datetime: Date
    
    public init(
        id: Int? = nil,
        contentType: MediaType,
        thumbnailURL: String,
        contentURL: String,
        datetime: Date
    ) {
        self.id = id ?? Self.generateID(from: contentURL)
        self.contentType = contentType
        self.thumbnailURL = thumbnailURL
        self.contentURL = contentURL
        self.datetime = datetime
    }
    
    public enum MediaType: Equatable {
        case image, video(playTime: Int)
    }
    
    private static func generateID(from string: String) -> Int {
        var hasher = Hasher()
        hasher.combine(string)
        return hasher.finalize()
    }
}
