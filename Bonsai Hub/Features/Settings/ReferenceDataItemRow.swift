//
//  ReferenceDataItemRow.swift
//  Bonsai World
//
//  List row for Reference Data Manager items.
//

import SwiftUI

struct ReferenceDataItemRow: View {
    let record: ReferenceDataRecord
    var onActiveChange: (Bool) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(record.name)
                    .font(FaloTypography.body)
                if let subtitle = record.subtitle {
                    Text(subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: FaloSpacing.medium)

            Text("\(record.sortOrder)")
                .font(FaloTypography.caption)
                .foregroundStyle(.tertiary)
                .monospacedDigit()
                .frame(minWidth: 28, alignment: .trailing)
                .help("Sort order")

            Toggle(
                "Active",
                isOn: Binding(
                    get: { record.isActive },
                    set: { onActiveChange($0) }
                )
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .controlSize(.small)
            .help(record.isActive ? "Active" : "Inactive")
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .opacity(record.isActive ? 1 : 0.55)
    }
}
