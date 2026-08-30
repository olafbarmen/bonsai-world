//
//  GalleryFilterMenu.swift
//  Bonsai World
//
//  Show ▼ filter control — menu picker; extend via GalleryBrowseFilter.
//

import SwiftUI

struct GalleryFilterMenu: View {
    @Binding var selection: GalleryBrowseFilter
    let options: [GalleryBrowseFilter]

    var body: some View {
        Picker(selection: $selection) {
            ForEach(options) { filter in
                Label(filter.title, systemImage: filter.systemImage)
                    .tag(filter)
            }
        } label: {
            HStack(spacing: FaloSpacing.xSmall) {
                Text("Show")
                    .font(FaloTypography.caption.weight(.medium))
                Text(selection.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(FaloColors.textSecondary)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .accessibilityLabel("Show filter")
        .accessibilityValue(selection.title)
    }
}
