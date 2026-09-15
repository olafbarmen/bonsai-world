//
//  FertilizerGuidesView.swift
//  Bonsai World
//
//  Knowledge → Fertilizer Guides — matrices first, short why underneath.
//

import SwiftUI

struct FertilizerGuidesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                titleBlock
                beforeYouFertilize
                glance
                whenToFeed
                speciesGuide
                pineTiming
                choosingFertilizer
                bottomLine
                inDepth
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Fertilizer Guides")
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(FertilizerGuides.chapterTitle)
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            Text(FertilizerGuides.openingLine)
                .font(FaloTypography.body)
        }
    }

    private var beforeYouFertilize: some View {
        DetailCard(title: "Before you fertilize") {
            Text("What is this tree trying to become?")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
                .padding(.bottom, FaloSpacing.xSmall)

            ForEach(FertilizerGuides.stageIntents, id: \.stage) { intent in
                HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
                    Text(intent.stage)
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: FaloSpacing.small)
                    Text(intent.action)
                        .font(FaloCardTypography.fieldValue)
                        .multilineTextAlignment(.trailing)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(intent.stage), \(intent.action)")
            }

            Text(FertilizerGuides.lookAtTheTree)
                .font(FaloTypography.body)
                .padding(.top, FaloSpacing.small)
        }
    }

    private var glance: some View {
        guideSection(
            title: "Fertilizing at a glance",
            note: FertilizerGuides.rhythmNote,
            why: FertilizerGuides.glanceWhy
        ) {
            KnowledgeGuideMatrix(
                leadingHeader: "",
                columnHeaders: FertilizerGuides.glanceColumnHeaders,
                rows: FertilizerGuides.glanceRows,
                leadingColumnWidth: 168
            )
        }
    }

    private var whenToFeed: some View {
        guideSection(
            title: "When does feeding start?",
            note: nil,
            why: FertilizerGuides.whenToFeedWhy
        ) {
            KnowledgeGuideMatrix(
                leadingHeader: "Tree signal",
                columnHeaders: ["Action"],
                rows: FertilizerGuides.whenToFeedRows,
                leadingColumnWidth: 220
            )
        }
    }

    private var speciesGuide: some View {
        guideSection(
            title: "Species guide",
            note: FertilizerGuides.startingPointsNote,
            why: nil
        ) {
            KnowledgeGuideMatrix(
                leadingHeader: "Species group",
                columnHeaders: FertilizerGuides.speciesColumnHeaders,
                rows: FertilizerGuides.speciesRows,
                leadingColumnWidth: 168
            )
        }
    }

    private var pineTiming: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Pine — special timing")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            HStack(alignment: .top, spacing: FaloSpacing.medium) {
                pineCard(title: "Single-flush pine", points: FertilizerGuides.pineSingleFlush)
                pineCard(title: "Double-flush pine", points: FertilizerGuides.pineDoubleFlush)
            }

            Text(FertilizerGuides.pineWhy)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
        }
    }

    private var choosingFertilizer: some View {
        guideSection(
            title: "Choosing a fertilizer",
            note: nil,
            why: FertilizerGuides.choosingWhy
        ) {
            KnowledgeGuideMatrix(
                leadingHeader: "What you want",
                columnHeaders: ["Useful approach"],
                rows: FertilizerGuides.choosingRows,
                leadingColumnWidth: 240
            )
        }
    }

    private var bottomLine: some View {
        DetailCard(title: "The bottom line") {
            Text(FertilizerGuides.bottomLine)
                .font(FaloTypography.body)
        }
    }

    private var inDepth: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                Text(FertilizerGuides.inDepthTitle)
                    .font(FaloTypography.headline)
                    .accessibilityAddTraits(.isHeader)
                Text(FertilizerGuides.inDepthLead)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            }

            cardRow(FertilizerGuides.inDepthStages)

            HStack(alignment: .top, spacing: FaloSpacing.medium) {
                DetailCard(title: "When to start") {
                    Text(FertilizerGuides.inDepthStartParagraphs[0])
                        .font(FaloTypography.body)
                    VStack(alignment: .leading, spacing: FaloSpacing.small) {
                        ForEach(FertilizerGuides.inDepthStartSigns, id: \.self) { item in
                            Text("· \(item)")
                                .font(FaloTypography.body)
                        }
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    Text(FertilizerGuides.inDepthStartParagraphs[1])
                        .font(FaloTypography.body)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)

                DetailCard(title: "When to reduce and stop") {
                    inDepthBody(paragraphs: FertilizerGuides.inDepthStopParagraphs)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            Text("Fertilizer types")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)
            cardGrid(FertilizerGuides.inDepthTypes)

            Text("The tree changes the answer")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)
            cardGrid(FertilizerGuides.inDepthSpecies)

            Text("A simple decision")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)
            cardRow(FertilizerGuides.inDepthDecision)
            Text(FertilizerGuides.inDepthDecisionClose)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)

            Text("Common mistakes")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)
            cardGrid(FertilizerGuides.inDepthMistakes)
        }
    }

    private func cardRow(_ cards: [FertilizerInDepthCard]) -> some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            ForEach(cards) { card in
                inDepthCard(card)
            }
        }
    }

    private func cardGrid(_ cards: [FertilizerInDepthCard]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: FaloSpacing.medium),
                GridItem(.flexible(), spacing: FaloSpacing.medium)
            ],
            alignment: .leading,
            spacing: FaloSpacing.medium
        ) {
            ForEach(cards) { card in
                inDepthCard(card)
            }
        }
    }

    private func inDepthCard(_ card: FertilizerInDepthCard) -> some View {
        DetailCard(title: card.title) {
            inDepthBody(lead: card.lead, paragraphs: card.paragraphs, bullets: card.bullets)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func inDepthBody(
        lead: String? = nil,
        paragraphs: [String] = [],
        bullets: [String] = []
    ) -> some View {
        if let lead {
            Text(lead)
                .font(FaloCardTypography.fieldValue)
                .padding(.bottom, FaloSpacing.xSmall)
        }
        ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
            Text(paragraph)
                .font(FaloTypography.body)
        }
        if !bullets.isEmpty {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                ForEach(Array(bullets.enumerated()), id: \.offset) { _, item in
                    Text("· \(item)")
                        .font(FaloTypography.body)
                }
            }
            .padding(.top, paragraphs.isEmpty && lead == nil ? 0 : FaloSpacing.xSmall)
        }
    }

    private func guideSection<Content: View>(
        title: String,
        note: String?,
        why: String?,
        @ViewBuilder matrix: @escaping () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            DetailCard(title: title) {
                matrix()
            }

            if let note {
                Text(note)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }

            if let why {
                Text(why)
                    .font(FaloTypography.body)
            }
        }
    }

    private func pineCard(title: String, points: [String]) -> some View {
        DetailCard(title: title) {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                    Text("· \(point)")
                        .font(FaloTypography.body)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

#Preview {
    FertilizerGuidesView()
        .frame(width: 980, height: 860)
}
