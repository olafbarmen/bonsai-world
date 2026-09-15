//
//  SpeciesStratificationProfileDetailView.swift
//  Bonsai World
//
//  Shared read-only presentation of one stratification profile.
//  Used by Species Selector and Settings.
//

import SwiftUI

struct SpeciesStratificationProfileDetailView: View {
    let profile: SpeciesStratificationProfile
    var showsStartAction: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            header
            summaryCard
            sequenceCard
            expandable("Treatment details") { treatmentDetails }
            expandable("Why this treatment?") {
                Text(profile.whyThisTreatment).font(FaloTypography.body)
            }
            expandable("Monitoring") {
                Text(profile.monitoringNotes).font(FaloTypography.body)
            }
            expandable("Germination") { germinationBody }
            expandable("Sources") { sourcesBody }
            expandable("Notes") { notesBody }

            if showsStartAction {
                Button("Start Stratification") {}
                    .disabled(true)
                    .help(SeedStratificationKnowledge.startActionPlaceholder)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(profile.scientificName)
                .font(FaloTypography.headline)
            Text(profile.commonName)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
            if !profile.bonsaiRelevance.isEmpty {
                Text(profile.bonsaiRelevance)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private var summaryCard: some View {
        DetailCard(title: "Summary") {
            DetailLabeledRow(label: "Treatment", value: profile.treatmentType.title)
            DetailLabeledRow(label: "Dormancy", value: profile.dormancyType.title)
            if let warm = profile.warmStep {
                if let temp = warm.temperatureLabel {
                    DetailLabeledRow(label: "Warm temperature", value: temp)
                }
                if let days = warm.durationLabel {
                    DetailLabeledRow(label: "Warm duration", value: days)
                } else if profile.treatmentType == .warmThenCold || profile.treatmentType == .variable {
                    DetailLabeledRow(label: "Warm duration", value: "Variable / see sequence")
                }
            }
            if let cold = profile.coldStep {
                if let temp = cold.temperatureLabel {
                    DetailLabeledRow(label: "Cold temperature", value: temp)
                } else {
                    DetailLabeledRow(label: "Cold temperature", value: "Variable")
                }
                if let days = cold.durationLabel {
                    DetailLabeledRow(label: "Cold duration", value: days)
                } else if cold.type == .coldStratification {
                    DetailLabeledRow(label: "Cold duration", value: "Variable")
                }
            }
            DetailLabeledRow(label: "Moisture", value: profile.moistureRequirement.title)
            StratificationConfidenceBadge(level: profile.confidenceLevel)
        }
    }

    private var sequenceCard: some View {
        DetailCard(title: "Treatment sequence") {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                ForEach(Array(profile.orderedSequence.enumerated()), id: \.element.id) { index, phase in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(phase.type.title)
                                .font(FaloCardTypography.fieldValue)
                            if phase.isOptional {
                                Text("optional")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        if let temp = phase.temperatureLabel {
                            Text(temp).font(FaloTypography.caption).foregroundStyle(.secondary)
                        }
                        if let days = phase.durationLabel {
                            Text(days).font(FaloTypography.caption).foregroundStyle(.secondary)
                        }
                        if !phase.notes.isEmpty {
                            Text(phase.notes).font(FaloTypography.caption).foregroundStyle(.secondary)
                        }
                    }
                    if index < profile.orderedSequence.count - 1 {
                        Image(systemName: "arrow.down")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }
                }
            }
            if !profile.alternativeTreatmentNotes.isEmpty {
                Text(profile.alternativeTreatmentNotes)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, FaloSpacing.small)
            }
        }
    }

    @ViewBuilder
    private var treatmentDetails: some View {
        DetailLabeledRow(label: "Treatment required", value: profile.treatmentRequired ? "Yes" : "No")
        DetailLabeledRow(label: "Scarification", value: profile.scarificationRequired ? "May be required" : "Not indicated as required")
        DetailLabeledRow(label: "Soaking", value: profile.soakingRequired ? "May help" : "Not indicated as required")
        DetailLabeledRow(label: "Difficulty", value: profile.difficulty.title)
    }

    @ViewBuilder
    private var germinationBody: some View {
        if let g = SpeciesStratificationProfile.temperatureRangeLabel(
            min: profile.germinationTemperatureMin,
            max: profile.germinationTemperatureMax
        ) {
            DetailLabeledRow(label: "Germination temperature", value: g)
        } else {
            Text("Move to suitable germination conditions after required treatment. Species-specific germination temperatures are not asserted unless sourced.")
                .font(FaloTypography.body)
        }
        if !profile.sowingDepthGuidance.isEmpty {
            Text(profile.sowingDepthGuidance)
                .font(FaloTypography.body)
        }
    }

    @ViewBuilder
    private var sourcesBody: some View {
        if profile.sources.isEmpty {
            Text("No sources attached — treat values as unverified.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
        } else {
            ForEach(profile.sources) { source in
                VStack(alignment: .leading, spacing: 2) {
                    Text(source.displayLine)
                        .font(FaloCardTypography.fieldValue)
                    Text(source.sourceType.title)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    if !source.referenceNote.isEmpty {
                        Text(source.referenceNote)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, FaloSpacing.xSmall)
            }
        }
    }

    @ViewBuilder
    private var notesBody: some View {
        Text(profile.notes.isEmpty ? "—" : profile.notes)
            .font(FaloTypography.body)
    }

    private func expandable<Content: View>(
        _ title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        DisclosureGroup(title) {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, FaloSpacing.xSmall)
        }
        .font(FaloTypography.caption.weight(.semibold))
    }
}
