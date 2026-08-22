//
//  RelatedCollectionsSection.swift
//  Bonsai World
//
//  Reusable related-collections list for Falo Detail pages.
//  Rows are prepared for future navigation via onSelect.
//

import SwiftUI

struct RelatedCollectionsSection: View {
    var title: String = "Collections"
    var showsHeader: Bool = true
    let items: [RelatedCollectionItem]
    /// Called when a row is chosen. Leave nil until navigation is wired.
    var onSelect: ((RelatedCollectionItem) -> Void)?
    var showsDisclosureIndicator: Bool = true
    var emptyTitle: String = "No Collections yet"
    var emptyDescription: String = "Collections that include related trees will appear here."

    var body: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            if showsHeader {
                DetailSectionHeader(title: title)
            }

            if items.isEmpty {
                EmptyStateView(
                    title: emptyTitle,
                    systemImage: "square.stack.3d.up",
                    description: emptyDescription
                )
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(items) { item in
                        RelatedCollectionRow(
                            item: item,
                            showsDisclosureIndicator: showsDisclosureIndicator,
                            isInteractive: onSelect != nil
                        ) {
                            onSelect?(item)
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

private struct RelatedCollectionRow: View {
    let item: RelatedCollectionItem
    var showsDisclosureIndicator: Bool
    var isInteractive: Bool
    var action: () -> Void

    var body: some View {
        let content = HStack(spacing: FaloSpacing.medium) {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 22, height: 22, alignment: .center)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(item.name)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(treeCountLabel)
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
            }

            if showsDisclosureIndicator {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, FaloSpacing.small)
        .contentShape(Rectangle())

        if isInteractive {
            Button(action: action) { content }
                .buttonStyle(.plain)
                .accessibilityHint(showsDisclosureIndicator ? "Opens this collection when available" : "Selects this collection")
        } else {
            content
        }
    }

    private var treeCountLabel: String {
        item.treeCount == 1 ? "1 Tree" : "\(item.treeCount) Trees"
    }
}

#Preview {
    RelatedCollectionsSection(items: [
        RelatedCollectionItem(id: UUID(), name: "Japanese Maples", treeCount: 4),
        RelatedCollectionItem(id: UUID(), name: "Deciduous Group", treeCount: 4)
    ])
    .padding()
    .frame(width: 420)
}
