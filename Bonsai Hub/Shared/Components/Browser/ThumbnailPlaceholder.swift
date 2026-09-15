//
//  ThumbnailPlaceholder.swift
//  Bonsai World
//
//  Shared media placeholder until Gallery assets exist.
//

import SwiftUI

struct ThumbnailPlaceholder: View {
    var systemImage: String = "leaf"
    var width: CGFloat = 52
    var height: CGFloat = 52

    init(systemImage: String = "leaf", size: CGFloat = 52) {
        self.systemImage = systemImage
        self.width = size
        self.height = size
    }

    init(systemImage: String = "leaf", width: CGFloat, height: CGFloat) {
        self.systemImage = systemImage
        self.width = width
        self.height = height
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(BonsaiWorldColors.sidebar)

            Image(systemName: systemImage)
                .font(.system(size: min(width, height) * 0.36, weight: .semibold))
                .foregroundStyle(BonsaiWorldColors.textTertiary)
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: width, height: height)
        .accessibilityHidden(true)
    }
}

#Preview {
    ThumbnailPlaceholder()
        .padding()
}
