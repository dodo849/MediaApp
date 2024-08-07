//
//  SkeletonView.swift
//  CommonFeature
//
//  Created by DOYEON LEE on 7/8/24.
//

import SwiftUI

public struct SkeletonView: View {
    @State private var opacity: Double = 0.1
    
    public init() { }
    
    public var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.3))
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.0)
                        .repeatForever(autoreverses: true)
                ) { opacity = 0.5 }
            }
    }
}

// MARK: - Preview
#Preview {
    SkeletonView()
}
