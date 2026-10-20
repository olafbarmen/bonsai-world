//
//  GalleryImagesToolbar.swift
//  Bonsai World
//
//  Images 1.1 top bar — Show ▼ · Search · Sort ▼
//

import SwiftUI

enum GalleryImageSort: String, CaseIterable, Identifiable {
    case latest
    case tree

    var id: String { rawValue }

    var title: String {
        switch self {
        case .latest: "Latest Images"
        case .tree: "By Tree"
        }
    }
}

struct GalleryTreeFilterChoice: Identifiable, Hashable {
    let id: UUID
    let title: String
}

struct GalleryImagesToolbar: View {
    @Binding var filter: GalleryBrowseFilter
    let filterOptions: [GalleryBrowseFilter]
    @Binding var searchText: String
    @Binding var imageSort: GalleryImageSort
    @Binding var treeFilterID: UUID?
    let treeChoices: [GalleryTreeFilterChoice]
    let imageCountLabel: String?

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            HStack(spacing: FaloSpacing.small) {
                showControl
                if filter == .byTree {
                    treeControl
                }

                if let imageCountLabel {
                    Text(imageCountLabel)
                        .font(FaloTypography.caption)
                        .foregroundStyle(FaloColors.textSecondary)
                }
            }

            Spacer(minLength: FaloSpacing.large)

            HStack(spacing: FaloSpacing.small) {
                searchField
                sortControl
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var showControl: some View {
        GalleryFilterMenu(selection: $filter, options: filterOptions)
    }

    private var treeControl: some View {
        Picker(selection: $treeFilterID) {
            Text("Trees").tag(UUID?.none)
            ForEach(treeChoices) { choice in
                Text(choice.title).tag(Optional(choice.id))
            }
        } label: {
            HStack(spacing: FaloSpacing.xSmall) {
                Text("Tree")
                    .font(FaloTypography.caption.weight(.medium))
                Text(selectedTreeTitle)
                    .font(FaloTypography.caption)
                    .foregroundStyle(FaloColors.textSecondary)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .accessibilityLabel("Tree")
        .accessibilityValue(selectedTreeTitle)
    }

    private var selectedTreeTitle: String {
        guard let treeFilterID,
              let choice = treeChoices.first(where: { $0.id == treeFilterID }) else {
            return "Trees"
        }
        return choice.title
    }

    private var searchField: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            Image(systemName: "magnifyingglass")
                .font(.caption.weight(.medium))
                .foregroundStyle(FaloColors.textSecondary)
            TextField("Search", text: $searchText)
                .textFieldStyle(.plain)
                .font(FaloTypography.caption.weight(.medium))
        }
        .padding(.horizontal, FaloSpacing.medium)
        .padding(.vertical, FaloSpacing.xSmall)
        .frame(minWidth: 180, alignment: .leading)
        .background(Color.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .accessibilityLabel("Search")
    }

    private var sortControl: some View {
        Picker(selection: $imageSort) {
            ForEach(GalleryImageSort.allCases) { sort in
                Text(sort.title).tag(sort)
            }
        } label: {
            HStack(spacing: FaloSpacing.xSmall) {
                Text("Sort")
                    .font(FaloTypography.caption.weight(.medium))
                Text(imageSort.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(FaloColors.textSecondary)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .accessibilityLabel("Sort")
        .accessibilityValue(imageSort.title)
    }
}
