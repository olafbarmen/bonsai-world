//
//  MeasurementHistorySection.swift
//  Bonsai World
//
//  Single source of truth for Tree measurements — horizontal timeline, newest first.
//  First column is the current (Latest) session. Older columns scroll horizontally.
//

import SwiftUI

struct MeasurementHistorySection: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.treeDetailContentWidth) private var contentWidth

    /// All sessions for the tree, newest Measurement Date first.
    let records: [TreeMeasurementRecord]
    /// Opens Add Measurement (Edit Mode only). Nil hides the button.
    var onAddMeasurement: (() -> Void)? = nil

    private var system: MeasurementSystem { appSettings.measurementSystem }

    var body: some View {
        DetailCard(title: "Measurement History") {
            if records.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .top, spacing: TreeDetailSpacing.cardGap) {
                        ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                            timelineColumn(record, isLatest: index == 0)
                                .frame(
                                    width: TreeDetailCardGridMetrics.columnWidth(in: contentWidth),
                                    alignment: .leading
                                )
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(maxWidth: .infinity, alignment: .leading)
                .faloScrollSurface()
            }

            if let onAddMeasurement {
                Button(action: onAddMeasurement) {
                    Label("Add Measurement", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .padding(.top, FaloSpacing.small)
                .help("Record a new dated measurement session")
                .accessibilityLabel("Add Measurement")
            }
        }
    }

    private var emptyState: some View {
        Text("No measurements yet")
            .font(FaloCardTypography.fieldValue)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func timelineColumn(_ record: TreeMeasurementRecord, isLatest: Bool) -> some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                if isLatest {
                    Text("Latest")
                        .font(FaloCardTypography.sectionTitle)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(FaloCardTypography.sectionTitleTracking)
                }

                Text(Self.dateLabel(record.measuredAt))
                    .font(isLatest ? FaloCardTypography.fieldValue : FaloCardTypography.sectionTitle)
                    .foregroundStyle(isLatest ? .primary : .secondary)
                    .textCase(isLatest ? nil : .uppercase)
                    .tracking(isLatest ? 0 : FaloCardTypography.sectionTitleTracking)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                dimensionRow("Height", record.heightMillimetres, .height)
                dimensionRow("Crown Width", record.crownWidthMillimetres, .crownWidth)
                dimensionRow("Nebari Width", record.nebariWidthMillimetres, .nebariWidth)
                dimensionRow("Trunk Diameter", record.trunkDiameterMillimetres, .trunkDiameter)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            isLatest
                ? "Latest, \(Self.dateLabel(record.measuredAt))"
                : Self.dateLabel(record.measuredAt)
        )
    }

    private func dimensionRow(
        _ title: String,
        _ millimetres: Int?,
        _ dimension: MeasurementDimension
    ) -> some View {
        DetailLabeledRow(
            label: title,
            value: MeasurementService.string(
                millimetres: millimetres,
                dimension: dimension,
                system: system
            )
        )
    }

    private static func dateLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
}
