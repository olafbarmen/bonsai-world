//
//  MobileSeedStratificationView.swift
//  Bonsai World
//

import SwiftUI

struct MobileSeedStratificationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                Text(SeedStratificationKnowledge.openingQuestion)
                    .font(FaloTypography.pageTitle)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)

                prose(title: "Introduction", paragraphs: SeedStratificationKnowledge.introduction)
                prose(title: "What Is Stratification?", paragraphs: SeedStratificationKnowledge.whatIsStratification)

                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    heading("Treatment Types")
                    ForEach(SeedStratificationKnowledge.treatmentCards) { card in
                        cardBlock(title: card.method.title) {
                            Text(card.summary)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                            Text(card.detail)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                    }
                }

                cardBlock(title: "Typical Workflow") {
                    ForEach(SeedStratificationKnowledge.workflowSteps) { step in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(step.id)  \(step.title)")
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                            Text(step.note)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    heading("Cold Stratification")
                    cardBlock(title: "At a glance") {
                        Text(StratificationMethod.coldMoist.title)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text(SeedStratificationKnowledge.educationalColdGlanceTemperature)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text(SeedStratificationKnowledge.educationalColdGlanceDuration)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text("These lines are educational orientation only. Species profiles will supply authoritative ranges with sources.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    cardBlock(title: "Medium") {
                        Text(SeedStratificationKnowledge.coldMediumIntro)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        ForEach(SeedStratificationKnowledge.coldMediumExamples, id: \.self) { example in
                            Text("· \(example)")
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                    prose(title: "Temperature", paragraphs: SeedStratificationKnowledge.coldTemperatureCopy)
                    prose(title: "Duration", paragraphs: SeedStratificationKnowledge.coldDurationCopy)
                    cardBlock(title: "Monitoring") {
                        ForEach(SeedStratificationKnowledge.coldMonitoring, id: \.self) { item in
                            Text("· \(item)")
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                }

                prose(title: "Warm → Cold Treatment", paragraphs: SeedStratificationKnowledge.warmThenColdCopy)
                prose(title: "Scarification", paragraphs: SeedStratificationKnowledge.scarificationCopy)

                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    heading("Common Mistakes")
                    ForEach(SeedStratificationKnowledge.commonMistakes) { mistake in
                        cardBlock(title: mistake.title) {
                            Text(mistake.detail)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                }

                Text("Recommendations should carry an evidence-quality label. Values without attached sources must not be presented as verified.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            .padding(FaloSpacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Seed Stratification")
    }

    private func heading(_ title: String) -> some View {
        Text(title)
            .font(FaloTypography.sectionHeading)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .accessibilityAddTraits(.isHeader)
    }

    private func prose(title: String, paragraphs: [String]) -> some View {
        cardBlock(title: title) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
            }
        }
    }

    private func cardBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
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
}
