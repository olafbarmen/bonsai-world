//
//  TreeFertilizationSection.swift
//  Bonsai World
//
//  Tree Detail — fertilization inputs (Tree-owned) + read-only recommendation
//  from Growing Intelligence. Rules live in the engine, not here.
//

import SwiftUI

struct TreeFertilizationSection: View {
    let plan: TreeFertilizationPlan
    let seasonTitle: String
    let treeStageName: String
    let fertilizationModeTitle: String

    @Binding var fertilizerHealth: FertilizerHealth?
    @Binding var fertilizerKindOverride: FertilizerKind?

    var isEditing: Bool
    /// When false, content is embedded (e.g. ExpandableSection) without a second raised card.
    var showsCardChrome: Bool = true

    var body: some View {
        Group {
            if showsCardChrome {
                DetailCard(title: "Fertilization") { fertilizationBody }
            } else {
                fertilizationBody
            }
        }
    }

    @ViewBuilder
    private var fertilizationBody: some View {
        inputsBlock

        Divider()
            .padding(.vertical, FaloSpacing.xSmall)

        recommendationBlock
    }

    /// Tree-owned / context fields the grower can change (or that feed the plan).
    @ViewBuilder
    private var inputsBlock: some View {
        if isEditing {
            kindPicker
            healthPicker
            DetailLabeledRow(label: "Season", value: seasonTitle)
            Text("Change these to update the recommendation below.")
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, FaloSpacing.xSmall)
        } else {
            if let kind = fertilizerKindOverride {
                DetailLabeledRow(label: "Kind of tree", value: kind.title)
            }
            DetailLabeledRow(label: "Tree Stage", value: treeStageName)
            DetailLabeledRow(label: "Fertilization mode", value: fertilizationModeTitle)
            DetailLabeledRow(label: "Condition", value: fertilizerHealth?.title ?? "")
            DetailLabeledRow(label: "Season", value: seasonTitle)
        }
    }

    /// Derived Growing Intelligence output — never edited here.
    @ViewBuilder
    private var recommendationBlock: some View {
        Text("Calculated from Kind of tree, Condition, Season, and Tree Stage.")
            .font(FaloTypography.caption)
            .foregroundStyle(BonsaiWorldColors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, FaloSpacing.xSmall)

        DetailLabeledRow(label: "Recommendation", value: plan.recommendation)
        DetailLabeledRow(label: "Type", value: plan.fertilizerType)
        DetailLabeledRow(label: "When", value: plan.when)
        DetailLabeledRow(label: "Goal", value: plan.goal)
        DetailLabeledRow(label: "Next review", value: plan.nextReview)

        if let reason = plan.reason {
            DetailLabeledRow(label: "Reason", value: reason)
        }

        Text(plan.note)
            .font(FaloTypography.caption)
            .foregroundStyle(.secondary)
            .padding(.top, FaloSpacing.xSmall)
    }

    private var kindPicker: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Kind of tree")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Picker("Kind of tree", selection: $fertilizerKindOverride) {
                Text("From species").tag(Optional<FertilizerKind>.none)
                ForEach(FertilizerKind.allCases) { kind in
                    Text(kind.title).tag(Optional(kind))
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, FaloSpacing.xSmall)
    }

    private var healthPicker: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Condition")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Picker("Condition", selection: $fertilizerHealth) {
                Text("Not confirmed").tag(Optional<FertilizerHealth>.none)
                ForEach(FertilizerHealth.allCases) { item in
                    Text(item.title).tag(Optional(item))
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, FaloSpacing.xSmall)
    }
}
