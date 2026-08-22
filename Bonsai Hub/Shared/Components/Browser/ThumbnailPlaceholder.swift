//
//  ThumbnailPlaceholder.swift
//  Bonsai World
//
//  Shared media placeholder until Gallery assets exist.
//

import SwiftUI

struct ThumbnailPlaceholder: View {
    var systemImage: String = "leaf"
    var size: CGFloat = 52

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.primary.opacity(0.06))

            Image(systemName: systemImage)
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

#Preview {
    ThumbnailPlaceholder()
        .padding()
}
