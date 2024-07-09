//
//  SearchMediaContentModel.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct SearchMediaContentModel: Equatable, Identifiable {
    public let id: String
    public let contentType: MediaType
    public let thumbnailURL: String
    public let contentURL: String
    public var datetime: Date
    
    public init(
        id: String,
        contentType: MediaType,
        thumbnailURL: String,
        contentURL: String,
        datetime: Date
    ) {
        self.id = id
        self.contentType = contentType
        self.thumbnailURL = thumbnailURL
        self.contentURL = contentURL
        self.datetime = datetime
    }
    
    public enum MediaType: Equatable {
        case image, video(playTime: TimeInterval)
    }
}
