//
//  TreeTimelineSection.swift
//  Bonsai World
//
//  Tree Detail — chronological history of this tree.
//
//  Timeline is a **consumer**, not a registration surface.
//  It assembles Work, Measurement, Photo, and Journal registrations into one history.
//  Care and Documents will follow the same pattern when they land.
//

import SwiftUI

struct TreeTimelineSection: View {
    let events: [TreeTimelineEvent]
    /// Overview uses plain chrome so Timeline does not compete with presence cards.
    var usesRaisedChrome: Bool = true
    var onViewTreeHistory: (() -> Void)? = nil

    private static let stillToCome = ["Care", "Documents"]

    var body: some View {
        Group {
            if usesRaisedChrome {
                DetailCard(title: "Timeline") {
                    timelineBody
                }
            } else {
                VStack(alignment: .leading, spacing: TreeOverviewSpacing.titleToContent) {
                    Text("Timeline")
                        .font(FaloTypography.sectionHeading)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityAddTraits(.isHeader)
                    timelineBody
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }

    @ViewBuilder
    private var timelineBody: some View {
        if events.isEmpty {
            Text("No activity registered yet. Use Context Tools → Add Work, Add Measurement, Add Photo, or Add Journal.")
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            VStack(spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    TreeTimelineRow(event: event)
                    if index < events.count - 1 {
                        Divider()
                    }
                }
            }
        }

        if let onViewTreeHistory {
            Button("View Tree History") {
                onViewTreeHistory()
            }
            .buttonStyle(.link)
            .padding(.top, FaloSpacing.xSmall)
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

private struct TreeTimelineRow: View {
    let event: TreeTimelineEvent

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: event.systemImage)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 20, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.headline)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)

                if let detail = event.detail, !detail.isEmpty {
                    Text(detail)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(event.date.formatted(date: .abbreviated, time: .omitted))
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(event.headline), \(event.date.formatted(date: .abbreviated, time: .omitted))")
    }
}
