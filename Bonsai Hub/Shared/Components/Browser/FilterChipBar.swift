//
//  FilterChipBar.swift
//  Bonsai World
//
//  Reusable filter chips for browser surfaces (Trees, future modules).
//

import SwiftUI

struct FilterChipLabel: View {
    let title: String
    var isSelected: Bool
    var systemImage: String?

    var body: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
            }
            Text(title)
                .font(FaloTypography.caption.weight(.semibold))
            if isSelected {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal, FaloSpacing.medium)
        .padding(.vertical, FaloSpacing.small)
        .background(
            Capsule(style: .continuous)
                .fill(isSelected ? Color.accentColor.opacity(0.18) : Color.primary.opacity(0.06))
        )
        .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct FilterChip: View {
    let title: String
    var isSelected: Bool
    var systemImage: String?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            FilterChipLabel(title: title, isSelected: isSelected, systemImage: systemImage)
        }
        .buttonStyle(.plain)
    }
}

struct FilterChipBar<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FaloSpacing.small) {
                content()
            }
            .padding(.horizontal, FaloSpacing.small)
            .padding(.vertical, FaloSpacing.xSmall)
        }
    }
}

#Preview {
    FilterChipBar {
        FilterChip(title: "Location", isSelected: false, systemImage: "mappin") {}
        FilterChip(title: "Greenhouse", isSelected: true, systemImage: "mappin") {}
        FilterChip(title: "Collection", isSelected: false, systemImage: "square.stack.3d.up") {}
    }
    .padding()
}
