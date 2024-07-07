//
//  MediaCell.swift
//  CommonFeature
//
//  Created by DOYEON LEE on 7/8/24.
//

import SwiftUI

import Kingfisher

public struct MediaCell: View {
    
    private let imageURL: String
    private let isSelected: Bool
    private let playTime: TimeInterval?
    private let date: Date
    
    public init(
        imageURL: String,
        isSelected: Bool = false,
        playTime: TimeInterval? = nil,
        date: Date
    ) {
        self.imageURL = imageURL
        self.isSelected = isSelected
        self.playTime = playTime
        self.date = date
    }
    
    public var body: some View {
        ZStack {
            KFImage(URL(string: imageURL)!)
                .placeholder({ SkeletonView() })
                .fade(duration: 0.5)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(Self.imageRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: Self.imageRadius)
                        .stroke(
                            isSelected
                            ? Color.blue
                            : Color.clear,
                            lineWidth: 2
                        )
                )
            
            if let playTime = playTime {
                dateAndPlaytimeOverlay(playTime, date)
            } else {
                dateAndPlaytimeOverlay(nil, date)
            }
            
            if isSelected {
                checkedImageOverlay
            }
        }
    }
    
    private var checkedImageOverlay: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "archivebox.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
        }
        .padding(Self.gridSpacing)
    }
    
    private func dateAndPlaytimeOverlay(
        _ playTime: TimeInterval? = nil,
        _ date: Date
    ) -> some View {
        VStack {
            Spacer()
            HStack {
                if let playTime = playTime {
                    Text(formattedPlayTime(playTime))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }
                Spacer()
            }
            HStack {
                    
                    Text(date, format: .dateTime)
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(.capsule)
                Spacer()
            }
        }
        .padding(Self.gridSpacing)
    }
    
    func formattedPlayTime(_ playTime: TimeInterval) -> String {
        let hours = Int(playTime) / 3600
        let minutes = (Int(playTime) % 3600) / 60
        let seconds = Int(playTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - View Contant
extension MediaCell {
    static let gridSpacing: CGFloat = 8
    static let imageRadius: CGFloat = 4
}