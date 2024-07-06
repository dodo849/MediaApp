//
//  MediaModel.swift
//  SearchFeature
//
//  Created by DOYEON LEE on 7/6/24.
//

import Foundation

public struct MediaModel: Equatable, Identifiable {
    public enum MediaType {
        case image, video
    }
    
    public init(mediaType: MediaType, thumbnailUrl: String) {
        self.id = UUID()
        self.mediaType = mediaType
        self.thumbnailUrl = thumbnailUrl
    }
    
    public let id: UUID
    public let mediaType: MediaType
    public let thumbnailUrl: String
}
