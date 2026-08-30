//
//  ImageWorkspaceFilmstripView.swift
//  Bonsai World
//
//  Related Images — other photos attached to the same library object (Tree, Pot, Tool, …).
//

import SwiftUI

struct ImageWorkspaceFilmstripView: View {
    let currentImageID: UUID
    let relatedEntries: [GalleryEntry]
    var onSelectRelated: ((GalleryEntry) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(filmstripTitle)
                .font(FaloTypography.caption.weight(.medium))
                .foregroundStyle(FaloColors.textSecondary)
                .padding(.horizontal, FaloSpacing.large)

            if relatedEntries.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(relatedEntries) { entry in
                            filmstripThumbnail(entry)
                        }
                    }
                    .padding(.horizontal, FaloSpacing.large)
                }
            }
        }
        .frame(height: ImageWorkspaceLayout.filmstripHeight)
        .frame(maxWidth: .infinity)
        .background(.bar)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(FaloColors.borderSubtle)
                .frame(height: 1)
        }
    }

    private var filmstripTitle: String {
        if relatedEntries.isEmpty {
            return "Related Images"
        }
        return "Related Images (\(relatedEntries.count))"
    }

    private var emptyState: some View {
        Text("No other images are attached to this object.")
            .font(FaloTypography.caption)
            .foregroundStyle(FaloColors.textSecondary)
            .padding(.horizontal, FaloSpacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func filmstripThumbnail(_ entry: GalleryEntry) -> some View {
        Button {
            onSelectRelated?(entry)
        } label: {
            ZStack {
                Color.primary.opacity(0.03)
                GalleryThumbnailImage(imageID: entry.id)
                    .padding(4)
            }
            .frame(width: 54, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(
                        entry.id == currentImageID ? Color.accentColor : FaloColors.borderSubtle,
                        lineWidth: entry.id == currentImageID ? 2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
        .help(entry.photoName)
    }
}
