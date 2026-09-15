//
//  SeedStratificationView.swift
//  Bonsai World
//
//  Seed Stratification knowledge — principles, treatments, workflow, confidence.
//  Species profiles come from SeedStratificationCatalogService (empty until Settings DB).
//

import SwiftUI

struct SeedStratificationView: View {
    @State private var selectedSpeciesID: UUID?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                titleBlock
                SeedStratificationSpeciesSelector(selectedSpeciesID: $selectedSpeciesID)
                introductionSection
                whatIsSection
                treatmentTypesSection
                workflowSection
                coldSection
                warmThenColdSection
                scarificationSection
                mistakesSection
                confidenceSection
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .bonsaiWorkspaceNavigationTitle("Seed Stratification")
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(SeedStratificationKnowledge.chapterTitle)
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            Text(SeedStratificationKnowledge.openingQuestion)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
        }
    }

    private var introductionSection: some View {
        proseCard(title: "Introduction", paragraphs: SeedStratificationKnowledge.introduction)
    }

    private var whatIsSection: some View {
        proseCard(title: "What Is Stratification?", paragraphs: SeedStratificationKnowledge.whatIsStratification)
    }

    private var treatmentTypesSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Treatment Types")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: FaloSpacing.medium),
                    GridItem(.flexible(), spacing: FaloSpacing.medium)
                ],
                alignment: .leading,
                spacing: FaloSpacing.medium
            ) {
                ForEach(SeedStratificationKnowledge.treatmentCards) { card in
                    treatmentCard(card)
                }
            }
        }
    }

    private func treatmentCard(_ card: SeedStratificationKnowledge.TreatmentCard) -> some View {
        DetailCard(title: card.method.title) {
            StratificationWhyDisclosure(
                summaryLines: [card.summary],
                whyBody: card.detail
            )
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var workflowSection: some View {
        DetailCard(title: "Typical Workflow") {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(SeedStratificationKnowledge.workflowSteps) { step in
                    HStack(alignment: .top, spacing: FaloSpacing.medium) {
                        Text("\(step.id)")
                            .font(FaloCardTypography.fieldLabel)
                            .foregroundStyle(.secondary)
                            .frame(width: 28, alignment: .trailing)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .font(FaloCardTypography.fieldValue)
                            Text(step.note)
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, FaloSpacing.small)
                    .accessibilityElement(children: .combine)

                    if step.id < SeedStratificationKnowledge.workflowSteps.count {
                        Divider()
                    }
                }
            }
        }
    }

    private var coldSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Cold Stratification")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            DetailCard(title: "At a glance") {
                StratificationWhyDisclosure(
                    summaryLines: [
                        StratificationMethod.coldMoist.title,
                        SeedStratificationKnowledge.educationalColdGlanceTemperature,
                        SeedStratificationKnowledge.educationalColdGlanceDuration
                    ],
                    whyBody: "These lines are educational orientation only. Species profiles will supply authoritative ranges with sources."
                )
            }

            DetailCard(title: "Medium") {
                Text(SeedStratificationKnowledge.coldMediumIntro)
                    .font(FaloTypography.body)
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(SeedStratificationKnowledge.coldMediumExamples, id: \.self) { example in
                        Text("· \(example)")
                            .font(FaloTypography.body)
                    }
                }
                .padding(.top, FaloSpacing.xSmall)
            }

            DetailCard(title: "Temperature") {
                ForEach(Array(SeedStratificationKnowledge.coldTemperatureCopy.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(FaloTypography.body)
                }
            }

            DetailCard(title: "Duration") {
                ForEach(Array(SeedStratificationKnowledge.coldDurationCopy.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(FaloTypography.body)
                }
            }

            DetailCard(title: "Monitoring") {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    ForEach(SeedStratificationKnowledge.coldMonitoring, id: \.self) { item in
                        Text("· \(item)")
                            .font(FaloTypography.body)
                    }
                }
            }
        }
    }

    private var warmThenColdSection: some View {
        DetailCard(title: "Warm → Cold Treatment") {
            ForEach(Array(SeedStratificationKnowledge.warmThenColdCopy.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
            }

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                sequenceRow("Warm phase")
                sequenceArrow()
                sequenceRow("Cold phase")
                sequenceArrow()
                sequenceRow("Germination")
            }
            .padding(.top, FaloSpacing.medium)
        }
    }

    private var scarificationSection: some View {
        DetailCard(title: "Scarification") {
            ForEach(Array(SeedStratificationKnowledge.scarificationCopy.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
            }
        }
    }

    private var mistakesSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Common Mistakes")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: FaloSpacing.medium),
                    GridItem(.flexible(), spacing: FaloSpacing.medium)
                ],
                alignment: .leading,
                spacing: FaloSpacing.medium
            ) {
                ForEach(SeedStratificationKnowledge.commonMistakes) { mistake in
                    DetailCard(title: mistake.title) {
                        Text(mistake.detail)
                            .font(FaloTypography.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
        }
    }

    private var confidenceSection: some View {
        DetailCard(title: "Scientific Confidence") {
            Text("Recommendations should carry an evidence-quality label. Values without attached sources must not be presented as verified.")
                .font(FaloTypography.body)
                .padding(.bottom, FaloSpacing.small)

            StratificationConfidenceLegend()
        }
    }

    private func proseCard(title: String, paragraphs: [String]) -> some View {
        DetailCard(title: title) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(FaloTypography.body)
            }
        }
    }

    private func sequenceRow(_ title: String) -> some View {
        Text(title)
            .font(FaloCardTypography.fieldValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, FaloSpacing.xSmall)
            .padding(.horizontal, FaloSpacing.small)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
            }
    }

    private func sequenceArrow() -> some View {
        Image(systemName: "arrow.down")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibilityHidden(true)
    }
}

#Preview {
    SeedStratificationView()
        .environment(SeedStratificationCatalogService())
}
