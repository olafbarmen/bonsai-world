//
//  MobileFertilizerGuidesView.swift
//  Bonsai World
//

import SwiftUI

struct MobileFertilizerGuidesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                Text(FertilizerGuides.openingLine)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)

                card(title: "Before you fertilize") {
                    Text("What is this tree trying to become?")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    ForEach(FertilizerGuides.stageIntents, id: \.stage) { intent in
                        labeled(intent.stage, intent.action)
                    }
                    Text(FertilizerGuides.lookAtTheTree)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }

                matrix(
                    title: "Fertilizing at a glance",
                    note: FertilizerGuides.rhythmNote,
                    why: FertilizerGuides.glanceWhy,
                    headers: FertilizerGuides.glanceColumnHeaders,
                    rows: FertilizerGuides.glanceRows
                )

                matrix(
                    title: "When does feeding start?",
                    note: nil,
                    why: FertilizerGuides.whenToFeedWhy,
                    headers: ["Action"],
                    rows: FertilizerGuides.whenToFeedRows
                )

                matrix(
                    title: "Species guide",
                    note: FertilizerGuides.startingPointsNote,
                    why: nil,
                    headers: FertilizerGuides.speciesColumnHeaders,
                    rows: FertilizerGuides.speciesRows
                )

                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    Text("Pine — special timing")
                        .font(FaloTypography.sectionHeading)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    bulletCard(title: "Single-flush pine", points: FertilizerGuides.pineSingleFlush)
                    bulletCard(title: "Double-flush pine", points: FertilizerGuides.pineDoubleFlush)
                    Text(FertilizerGuides.pineWhy)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                matrix(
                    title: "Choosing a fertilizer",
                    note: nil,
                    why: FertilizerGuides.choosingWhy,
                    headers: ["Useful approach"],
                    rows: FertilizerGuides.choosingRows
                )

                card(title: "The bottom line") {
                    Text(FertilizerGuides.bottomLine)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }

                Text(FertilizerGuides.inDepthTitle)
                    .font(FaloTypography.pageTitle)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(FertilizerGuides.inDepthLead)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)

                inDepthCards(FertilizerGuides.inDepthStages)

                card(title: "When to start") {
                    if let first = FertilizerGuides.inDepthStartParagraphs.first {
                        Text(first)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    ForEach(FertilizerGuides.inDepthStartSigns, id: \.self) { item in
                        Text("· \(item)")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    ForEach(Array(FertilizerGuides.inDepthStartParagraphs.dropFirst()), id: \.self) { paragraph in
                        Text(paragraph)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                }

                card(title: "When to reduce and stop") {
                    ForEach(FertilizerGuides.inDepthStopParagraphs, id: \.self) { paragraph in
                        Text(paragraph)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                }

                Text("Fertilizer types")
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                inDepthCards(FertilizerGuides.inDepthTypes)

                Text("The tree changes the answer")
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                inDepthCards(FertilizerGuides.inDepthSpecies)

                Text("A simple decision")
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                inDepthCards(FertilizerGuides.inDepthDecision)
                Text(FertilizerGuides.inDepthDecisionClose)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)

                Text("Common mistakes")
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                inDepthCards(FertilizerGuides.inDepthMistakes)
            }
            .padding(FaloSpacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Fertilizer Guides")
    }

    private func matrix(
        title: String,
        note: String?,
        why: String?,
        headers: [String],
        rows: [KnowledgeGuideMatrixRow]
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(title)
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            if let note {
                Text(note)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            ForEach(rows) { row in
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(row.leading)
                        .font(FaloTypography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    ForEach(Array(row.cells.enumerated()), id: \.offset) { index, cell in
                        let label = index < headers.count ? headers[index] : ""
                        labeled(label, cell)
                    }
                }
                .padding(FaloSpacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BonsaiWorldColors.surface, in: RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
            }
            if let why {
                Text(why)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
        }
    }

    private func inDepthCards(_ cards: [FertilizerInDepthCard]) -> some View {
        ForEach(cards) { card in
            self.card(title: card.title) {
                if let lead = card.lead, !lead.isEmpty {
                    Text(lead)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
                ForEach(card.paragraphs, id: \.self) { paragraph in
                    Text(paragraph)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
                ForEach(card.bullets, id: \.self) { bullet in
                    Text("· \(bullet)")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                }
            }
        }
    }

    private func bulletCard(title: String, points: [String]) -> some View {
        card(title: title) {
            ForEach(points, id: \.self) { point in
                Text("· \(point)")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
        }
    }

    private func card<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(title)
                .font(FaloTypography.sectionHeading)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .padding(FaloSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BonsaiWorldColors.surface, in: RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
    }

    private func labeled(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if !label.isEmpty {
                Text(label)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            Text(value)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}
