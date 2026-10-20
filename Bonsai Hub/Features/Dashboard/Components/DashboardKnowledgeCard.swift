//
//  DashboardKnowledgeCard.swift
//  Bonsai World
//
//  Dashboard Knowledge — entry points into existing Knowledge destinations.
//  Titles match real destinations; no fabricated articles or counts.
//  Icon LEFT of title/subtitle as one horizontal information group.
//  Quick Guides omitted — Knowledge route is still a placeholder.
//  Soil & Substrate and Pots & Containers live inside Bonsai Handbook (not separate cards).
//

import SwiftUI

struct DashboardKnowledgeCard: View {
    var fillsRowHeight: Bool = false

    @Environment(AppState.self) private var appState

    private struct Destination: Identifiable {
        var id: String
        var title: String
        var subtitle: String
        var systemImage: String
        var open: () -> Void
    }

    /// Functional Knowledge destinations only (no Quick Guides placeholder).
    private var destinations: [Destination] {
        [
            Destination(
                id: "species",
                title: AppRoute.knowledgeSpeciesLibrary.title,
                subtitle: "Species",
                systemImage: "leaf",
                open: { appState.selectSection(.knowledgeSpeciesLibrary) }
            ),
            Destination(
                id: "handbook",
                title: AppRoute.knowledgeHandbook.title,
                subtitle: "Handbook",
                systemImage: "book",
                open: { appState.selectSection(.knowledgeHandbook) }
            ),
            Destination(
                id: "fertilizer",
                title: AppRoute.knowledgeFertilizerGuides.title,
                subtitle: "Care",
                systemImage: "leaf.circle",
                open: { appState.selectSection(.knowledgeFertilizerGuides) }
            )
        ]
    }

    /// ~20% above shared informational / displayLabel / caption — Knowledge card only.
    private enum KnowledgeScale {
        static let icon: CGFloat = 22
        static let iconWell: CGFloat = 34
        static let title: Font = .system(size: 16, weight: .medium, design: .default)
        static let subtitle: Font = .system(size: 12, weight: .regular, design: .default)
    }

    var body: some View {
        DashboardCard(
            id: .knowledge,
            prominence: .secondary,
            fillsRowHeight: fillsRowHeight,
            compact: true
        ) {
            HStack(alignment: .top, spacing: FaloSpacing.small) {
                ForEach(destinations) { item in
                    knowledgeItem(item)
                }
            }
        }
    }

    private func knowledgeItem(_ item: Destination) -> some View {
        DashboardCardTapButton(action: item.open) {
            HStack(alignment: .top, spacing: FaloSpacing.xSmall) {
                Image(systemName: item.systemImage)
                    .font(.system(size: KnowledgeScale.icon, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(width: KnowledgeScale.iconWell, height: KnowledgeScale.iconWell)
                    .background {
                        RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                            .fill(BonsaiWorldColors.accentSubtle)
                    }
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(KnowledgeScale.title)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(item.subtitle)
                        .font(KnowledgeScale.subtitle)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
