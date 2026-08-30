//
//  RelatedTreesSection.swift
//  Bonsai World
//
//  Reusable related-trees list for Falo Detail pages.
//  With onRemove: membership workspace rows (open primary, Remove secondary).
//

import SwiftUI

struct RelatedTreesSection: View {
    var title: String = "Trees"
    var showsHeader: Bool = true
    /// Optional one-line guidance under the section title (membership contexts).
    var supportingText: String? = nil
    let items: [RelatedTreeItem]
    var emptyTitle: String = "No Trees yet"
    var emptyDescription: String = "Trees linked here will appear in this list."
    /// Called when a row is chosen. Leave nil until navigation is wired.
    var onSelect: ((RelatedTreeItem) -> Void)?
    /// When set, each row shows a secondary Remove control for Collection membership.
    /// Does not delete the Tree.
    var onRemove: ((RelatedTreeItem) -> Void)?

    private var isMembershipWorkspace: Bool { onRemove != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            if showsHeader || !(supportingText?.isEmpty ?? true) {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    if showsHeader {
                        DetailSectionHeader(title: title)
                    }

                    if let supportingText, !supportingText.isEmpty {
                        Text(supportingText)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            if items.isEmpty {
                EmptyStateView(
                    title: emptyTitle,
                    systemImage: "leaf",
                    description: emptyDescription
                )
            } else if isMembershipWorkspace {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(items) { item in
                        MembershipTreeRow(
                            item: item,
                            onSelect: { onSelect?(item) },
                            onRemove: { onRemove?(item) }
                        )
                    }
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        RelatedTreeRow(
                            item: item,
                            onSelect: { onSelect?(item) }
                        )
                        if index < items.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

// MARK: - Membership workspace row (Collection Detail)

private struct MembershipTreeRow: View {
    let item: RelatedTreeItem
    var onSelect: () -> Void
    var onRemove: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            Button(action: onSelect) {
                HStack(alignment: .center, spacing: FaloSpacing.medium) {
                    TreeListThumbnail(imageID: item.imageID)

                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(item.name)
                            .font(FaloTypography.body)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(subtitle)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
                .padding(.vertical, FaloSpacing.medium)
                .padding(.leading, FaloSpacing.medium)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Opens this tree")

            Button("Remove", action: onRemove)
                .buttonStyle(.plain)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .padding(.trailing, FaloSpacing.medium)
                .help("Remove from Collection")
                .accessibilityLabel("Remove from Collection")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(Color.primary.opacity(0.025))
        }
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
    }

    private var subtitle: String {
        let species = FaloDisplayValue.text(item.species)
        let place = FaloDisplayValue.text(item.collectionName)
        if place.isEmpty || place == FaloDisplayValue.empty {
            return species
        }
        return "\(species) · \(place)"
    }
}

// MARK: - Simple related row (no membership controls)

private struct RelatedTreeRow: View {
    let item: RelatedTreeItem
    var onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: FaloSpacing.medium) {
                TreeListThumbnail(imageID: item.imageID)

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(item.name)
                        .font(FaloTypography.body)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, FaloSpacing.small)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens this tree when available")
    }

    private var subtitle: String {
        let species = FaloDisplayValue.text(item.species)
        let collection = FaloDisplayValue.text(item.collectionName)
        return "\(species) · \(collection)"
    }
}

#Preview("Membership") {
    RelatedTreesSection(
        title: "Members",
        supportingText: "Open a tree to view it, or remove it from this collection.",
        items: [
            RelatedTreeItem(
                id: UUID(),
                name: "Crimson Queen",
                species: "Acer palmatum 'Crimson Queen'",
                collectionName: "Maple Bench"
            ),
            RelatedTreeItem(
                id: UUID(),
                name: "Deshojo",
                species: "Acer palmatum 'Deshojo'",
                collectionName: "Maple Bench"
            )
        ],
        onSelect: { _ in },
        onRemove: { _ in }
    )
    .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
    .padding()
    .frame(width: 480)
}

#Preview("Simple") {
    RelatedTreesSection(items: [
        RelatedTreeItem(
            id: UUID(),
            name: "Crimson Queen",
            species: "Acer palmatum 'Crimson Queen'",
            collectionName: "Japanese Maples"
        )
    ])
    .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
    .padding()
    .frame(width: 420)
}
