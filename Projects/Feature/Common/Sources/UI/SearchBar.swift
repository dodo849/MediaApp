//
//  SearchBar.swift
//  CommonFeature
//
//  Created by DOYEON LEE on 7/8/24.
//

import SwiftUI

public struct SearchBar: View {
    @Binding private var text: String
    private var isDummy: Bool
    
    public init(
        text: Binding<String>,
        isDummy: Bool = false
    ) {
        self._text = text
        self.isDummy = isDummy
    }
    
    public var body: some View {
        HStack {
            TextField("이미지/동영상 검색하기", text: $text)
                .disabled(isDummy)
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(.gray.opacity(0.1))
        .foregroundStyle(.black.opacity(0.7))
        .clipShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    SearchBar(text: .constant(""))
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDisplayName("SearchBar")
}
