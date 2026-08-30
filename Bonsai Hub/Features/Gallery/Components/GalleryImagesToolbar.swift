//
//  GalleryImagesToolbar.swift
//  Bonsai World
//
//  Images 1.1 top bar — Show ▼ · Search · Sort ▼
//

import SwiftUI

struct GalleryImagesToolbar: View {
    @Binding var filter: GalleryBrowseFilter
    let filterOptions: [GalleryBrowseFilter]
    let imageCountLabel: String?

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            HStack(spacing: FaloSpacing.small) {
                showControl

                if let imageCountLabel {
                    Text(imageCountLabel)
                        .font(FaloTypography.caption)
                        .foregroundStyle(FaloColors.textSecondary)
                }
            }

            Spacer(minLength: FaloSpacing.large)

            HStack(spacing: FaloSpacing.small) {
                searchPlaceholder
                sortPlaceholder
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var showControl: some View {
        GalleryFilterMenu(selection: $filter, options: filterOptions)
    }

    private var searchPlaceholder: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            Image(systemName: "magnifyingglass")
                .font(.caption.weight(.medium))
            Text("Search")
                .font(FaloTypography.caption.weight(.medium))
        }
        .foregroundStyle(FaloColors.textSecondary.opacity(0.5))
        .padding(.horizontal, FaloSpacing.medium)
        .padding(.vertical, FaloSpacing.xSmall)
        .frame(minWidth: 140, alignment: .leading)
        .background(Color.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .help("Search — coming soon")
        .accessibilityLabel("Search, coming soon")
        .allowsHitTesting(false)
    }

    private var sortPlaceholder: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            Text("Sort")
                .font(FaloTypography.caption.weight(.medium))
            Image(systemName: "chevron.down")
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(FaloColors.textSecondary.opacity(0.5))
        .padding(.horizontal, FaloSpacing.small)
        .padding(.vertical, FaloSpacing.xSmall)
        .background(Color.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .help("Sort — coming soon")
        .accessibilityLabel("Sort, coming soon")
        .allowsHitTesting(false)
    }
}
