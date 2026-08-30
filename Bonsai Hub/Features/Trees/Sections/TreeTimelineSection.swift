//
//  TreeTimelineSection.swift
//  Bonsai World
//
//  Tree Detail — chronological history of this tree.
//
//  Timeline is a **consumer**, not a registration surface.
//  Activities are registered on the Tree (Work today; Care, Measurements, Photos,
//  Journal, and Documents will follow the same pattern). Timeline assembles those
//  events into one chronological history for this bonsai — it does not create them.
//

import SwiftUI

struct TreeTimelineSection: View {
    let records: [WorkRecord]
    /// Resolves a Work Type id to its display name (Reference Data lookup).
    var workTypeName: (UUID) -> String?

    private static let stillToCome = ["Care", "Measurements", "Photos", "Journal", "Documents"]

    var body: some View {
        DetailCard(title: "Timeline") {
            if records.isEmpty {
                Text("No activity registered yet. Use Add Activity above to register Work on this tree.")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                        TreeTimelineRow(
                            record: record,
                            workTypeName: workTypeName(record.workTypeID)
                        )
                        if index < records.count - 1 {
                            Divider()
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Prepared for")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                ForEach(Self.stillToCome, id: \.self) { item in
                    Text("· \(item)")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, FaloSpacing.xSmall)
        }
    }
}

private struct TreeTimelineRow: View {
    let record: WorkRecord
    let workTypeName: String?

    private var trimmedNotes: String {
        record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 20, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(workTypeName ?? "Work")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)

                if !trimmedNotes.isEmpty {
                    Text(trimmedNotes)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(record.performedAt.formatted(date: .abbreviated, time: .omitted))
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}
