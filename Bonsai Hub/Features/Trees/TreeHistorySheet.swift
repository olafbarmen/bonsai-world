//
//  TreeHistorySheet.swift
//  Bonsai World
//
//  View + Print / Save as PDF for Tree History (assembled from Library records).
//  Layout: section cards, Care Work, Development photos. Print includes photos.
//

import AppKit
import SwiftUI

struct TreeHistorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ImageService.self) private var imageService

    let document: TreeHistoryDocument

    @State private var isPrinting = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                    Text(document.title)
                        .font(FaloTypography.headline)

                    if document.isEmpty {
                        Text("No history recorded yet.")
                            .font(FaloCardTypography.fieldValue)
                            .foregroundStyle(.secondary)
                    } else {
                        linesCard(title: "Identity", lines: document.identityLines)
                        linesCard(title: "Acquisition", lines: document.acquisitionLines)
                        linesCard(title: "Yamadori", lines: document.yamadoriLines)
                        textCard(title: "Known History", text: document.knownHistory)
                        journalCard(title: "Journal — Before Ownership", entries: document.journalBefore)
                        journalCard(title: "Journal", entries: document.journalDuring)
                        careWorkCard(
                            title: "Watering",
                            summary: document.wateringSummaryLine,
                            lines: document.wateringLines,
                            emptyWhenSummaryOnly: "No watering Work registered yet."
                        )
                        careWorkCard(
                            title: "Fertilizing",
                            summary: document.fertilizingSummaryLine,
                            lines: document.fertilizingLines,
                            emptyWhenSummaryOnly: "No fertilizing Work registered yet."
                        )
                        repottingCard
                        developmentCard
                        timelineCard
                        textCard(title: "Notes", text: document.notes)
                    }
                }
                .padding(FaloSpacing.xLarge)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()

            HStack {
                Button("Print…") {
                    Task { @MainActor in
                        isPrinting = true
                        await MacPrintTreeHistory.run(document: document, imageService: imageService)
                        isPrinting = false
                    }
                }
                .keyboardShortcut("p", modifiers: [.command])
                .disabled(isPrinting)

                if isPrinting {
                    ProgressView()
                        .controlSize(.small)
                }

                Spacer()

                Button("Done") { dismiss() }
                    .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(minWidth: 560, minHeight: 520)
        .navigationTitle("Tree History")
    }

    @ViewBuilder
    private func careWorkCard(
        title: String,
        summary: String?,
        lines: [String],
        emptyWhenSummaryOnly: String
    ) -> some View {
        let hasSummary = !(summary?.isEmpty ?? true)
        let hasRows = !lines.isEmpty
        if hasSummary || hasRows {
            DetailCard(title: title) {
                if let summary, !summary.isEmpty {
                    Text(summary)
                        .font(FaloCardTypography.fieldValue)
                        .padding(.bottom, hasRows ? FaloSpacing.small : 0)
                }
                if hasRows {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(FaloTypography.body)
                        }
                    }
                } else if hasSummary {
                    Text(emptyWhenSummaryOnly)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var repottingCard: some View {
        careWorkCard(
            title: "Repotting",
            summary: document.currentPotLine,
            lines: document.repottingLines,
            emptyWhenSummaryOnly: "No repotting Work registered yet."
        )
    }

    @ViewBuilder
    private var developmentCard: some View {
        if !document.developmentPhotos.isEmpty {
            DetailCard(title: "Development") {
                Text("Oldest → newest")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, FaloSpacing.small)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: FaloSpacing.medium) {
                        ForEach(document.developmentPhotos) { photo in
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                TreeListThumbnail(
                                    imageID: photo.id,
                                    imageService: imageService,
                                    width: 72,
                                    height: 96
                                )
                                Text(photo.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                                let name = photo.name.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !name.isEmpty {
                                    Text(name)
                                        .font(FaloTypography.caption)
                                        .lineLimit(2)
                                        .frame(width: 72, alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var timelineCard: some View {
        if !document.timelineEvents.isEmpty {
            DetailCard(title: "Timeline") {
                VStack(spacing: 0) {
                    ForEach(Array(document.timelineEvents.enumerated()), id: \.element.id) { index, event in
                        timelineRow(event)
                        if index < document.timelineEvents.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private func timelineRow(_ event: TreeTimelineEvent) -> some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: event.systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.headline)
                    .font(FaloCardTypography.fieldValue)
                Text(event.date.formatted(date: .abbreviated, time: .omitted))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if let detail = event.detail, !detail.isEmpty {
                    Text(detail)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    @ViewBuilder
    private func linesCard(title: String, lines: [String]) -> some View {
        let filtered = lines.filter { !$0.isEmpty }
        if !filtered.isEmpty {
            DetailCard(title: title) {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(Array(filtered.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(FaloTypography.body)
                            .textSelection(.enabled)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func textCard(title: String, text: String) -> some View {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            DetailCard(title: title) {
                Text(trimmed)
                    .font(FaloTypography.body)
                    .textSelection(.enabled)
            }
        }
    }

    @ViewBuilder
    private func journalCard(title: String, entries: [JournalEntry]) -> some View {
        if !entries.isEmpty {
            DetailCard(title: title) {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    ForEach(entries) { entry in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.recordedAt.formatted(date: .abbreviated, time: .omitted))
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                            Text(entry.text)
                                .font(FaloTypography.body)
                                .textSelection(.enabled)
                        }
                    }
                }
            }
        }
    }
}

private extension TreeHistoryDocument {
    var isEmpty: Bool {
        identityLines.allSatisfy(\.isEmpty)
            && acquisitionLines.allSatisfy(\.isEmpty)
            && yamadoriLines.allSatisfy(\.isEmpty)
            && knownHistory.isEmpty
            && journalBefore.isEmpty
            && journalDuring.isEmpty
            && (wateringSummaryLine?.isEmpty ?? true)
            && wateringLines.isEmpty
            && (fertilizingSummaryLine?.isEmpty ?? true)
            && fertilizingLines.isEmpty
            && (currentPotLine?.isEmpty ?? true)
            && repottingLines.isEmpty
            && developmentPhotos.isEmpty
            && timelineEvents.isEmpty
            && notes.isEmpty
    }
}
