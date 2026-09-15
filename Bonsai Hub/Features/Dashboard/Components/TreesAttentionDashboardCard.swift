//
//  TreesAttentionDashboardCard.swift
//  Bonsai World
//
//  Dashboard Trees Requiring Attention — live Tree health (Needs Attention /
//  Recovering). Read-only; tap opens Tree Detail. Primary work area.
//

import SwiftUI

struct TreesAttentionDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var fillsRowHeight: Bool = false

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState
    @Environment(ImageService.self) private var imageService

    private let rowLimit = 6
    /// Preferred Dashboard tree-photo frame — 5:6 (list-oriented, not hero).
    private let thumbWidth: CGFloat = 50
    private let thumbHeight: CGFloat = 60
    /// Floor for primary working presence when few trees are listed; content may grow past this.
    private static let minimumWorkingHeight: CGFloat = 280

    private var watchedTrees: [Tree] {
        treeService.treesInCare
            .filter { $0.healthStatus == .needsAttention || $0.healthStatus == .recovering }
            .sorted { $0.bonsaiName.localizedStandardCompare($1.bonsaiName) == .orderedAscending }
    }

    var body: some View {
        DashboardCard(
            id: .treesRequiringAttention,
            prominence: prominence,
            fillsRowHeight: fillsRowHeight,
            compact: true,
            titleOverride: "Trees Requiring Attention"
        ) {
            if watchedTrees.isEmpty {
                DashboardEmptyMessage(text: "No trees need attention.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(watchedTrees.prefix(rowLimit)) { tree in
                        DashboardCardTapButton {
                            appState.showTreeFromMap(treeID: tree.id)
                        } label: {
                            attentionRow(for: tree)
                        }
                    }

                    let extra = watchedTrees.count - rowLimit
                    if extra > 0 {
                        Text("\(extra) more in Garden")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                            .padding(.top, FaloSpacing.xSmall)
                    }
                }
            }
        }
        .frame(minHeight: Self.minimumWorkingHeight, alignment: .topLeading)
    }

    private func attentionRow(for tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            attentionLeading(for: tree)

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.bonsaiName)
                    .font(FaloTypography.cardRowTitle)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(1)

                if let species = speciesLine(for: tree) {
                    Text(species)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(1)
                }
            }
            .layoutPriority(1)

            // Same domain field as Tree Detail → Growing → Health (why this row is listed).
            Text(attentionReason(for: tree))
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            FaloStatusBadge(
                title: tree.healthStatus.title,
                tint: badgeTint(for: tree.healthStatus)
            )
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    /// Concise reason from the same ``Tree/healthStatus`` that includes the tree in this list.
    private func attentionReason(for tree: Tree) -> String {
        "Health · \(tree.healthStatus.title)"
    }

    @ViewBuilder
    private func attentionLeading(for tree: Tree) -> some View {
        if tree.listImageID != nil {
            TreeListThumbnail(
                imageID: tree.listImageID,
                imageService: imageService,
                width: thumbWidth,
                height: thumbHeight
            )
        } else {
            // Neutral empty — no decorative leaf as a photo substitute.
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(BonsaiWorldColors.surface)
                .frame(width: thumbWidth, height: thumbHeight)
                .overlay {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
                }
                .accessibilityHidden(true)
        }
    }

    private func speciesLine(for tree: Tree) -> String? {
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? nil : botanical
    }

    private func badgeTint(for status: TreeHealthStatus) -> Color {
        switch status {
        case .needsAttention: BonsaiWorldColors.statusAttention
        case .recovering: BonsaiWorldColors.statusInformation
        case .thriving, .stable: BonsaiWorldColors.accent
        }
    }
}
