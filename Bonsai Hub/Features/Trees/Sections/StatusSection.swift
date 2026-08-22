//
//  StatusSection.swift
//  Bonsai World
//
//  Tree Detail — Status card (Health, Tree Status, Size Class).
//

import SwiftUI

struct StatusSection: View {
    @Binding var healthStatus: TreeHealthStatus
    @Binding var treeStatusID: UUID?
    @Binding var sizeClassID: UUID?

    let treeStatuses: [DetailPickerOption]
    let sizeClasses: [DetailPickerOption]

    var isEditing: Bool

    var body: some View {
        DetailCard(title: "Status") {
            if isEditing {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Health")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    Picker("Health", selection: $healthStatus) {
                        ForEach(TreeHealthStatus.allCases) { status in
                            Text(status.title).tag(status)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, FaloSpacing.xSmall)

                DetailOptionPickerRow(
                    label: "Tree Status",
                    selection: $treeStatusID,
                    placeholder: "Select Tree Status",
                    options: treeStatuses
                )
                DetailOptionPickerRow(
                    label: "Size Class",
                    selection: $sizeClassID,
                    placeholder: "Select Size Class",
                    options: sizeClasses
                )
            } else {
                DetailLabeledRow(label: "Health", value: healthStatus.title)
                DetailLabeledRow(
                    label: "Tree Status",
                    value: DetailOptionPickerRow.displayName(for: treeStatusID, in: treeStatuses)
                )
                DetailLabeledRow(
                    label: "Size Class",
                    value: DetailOptionPickerRow.displayName(for: sizeClassID, in: sizeClasses)
                )
            }
        }
    }
}
