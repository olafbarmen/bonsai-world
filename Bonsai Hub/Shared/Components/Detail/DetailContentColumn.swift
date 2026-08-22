//
//  DetailContentColumn.swift
//  Bonsai World
//
//  Shared Detail reading column: max width, margins, section rhythm.
//

import SwiftUI

struct DetailContentColumn<Content: View>: View {
    var maxContentWidth: CGFloat = 720
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, FaloSpacing.xLarge)
            .padding(.bottom, FaloSpacing.xLarge)
            .frame(maxWidth: maxContentWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Vertical stack of Detail sections with consistent inter-card spacing.
struct DetailSectionStack<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            content()
        }
    }
}
