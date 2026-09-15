//
//  TreeHistoryDocument.swift
//  Bonsai World
//
//  Assembles Tree History from existing Tree registrations + Journal.
//  Presentation / export only — does not own source records.
//

import Foundation

struct TreeHistoryPhoto: Identifiable, Hashable, Sendable {
    let id: UUID
    let date: Date
    let name: String
}

struct TreeHistoryDocument: Sendable {
    let title: String
    let identityLines: [String]
    let acquisitionLines: [String]
    let yamadoriLines: [String]
    let knownHistory: String
    let journalBefore: [JournalEntry]
    let journalDuring: [JournalEntry]
    let wateringSummaryLine: String?
    let wateringLines: [String]
    let fertilizingSummaryLine: String?
    let fertilizingLines: [String]
    let currentPotLine: String?
    let repottingLines: [String]
    /// Oldest → newest (development sequence).
    let developmentPhotos: [TreeHistoryPhoto]
    /// Other Work + Measurement (Care Work and photos have their own sections).
    let timelineEvents: [TreeTimelineEvent]
    let notes: String

    var plainText: String {
        var parts: [String] = ["Tree History — \(title)", ""]
        var wroteSection = false

        func appendSection(_ heading: String, _ content: String) {
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            wroteSection = true
            parts.append(heading)
            parts.append(String(repeating: "—", count: heading.count))
            parts.append(content)
            parts.append("")
        }

        appendSection("Identity", identityLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        appendSection("Acquisition", acquisitionLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        appendSection("Yamadori", yamadoriLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        appendSection("Known History", knownHistory)

        if !journalBefore.isEmpty {
            appendSection(
                "Journal — Before Ownership",
                journalBefore.map(Self.formatJournal).joined(separator: "\n\n")
            )
        }
        if !journalDuring.isEmpty {
            appendSection(
                "Journal",
                journalDuring.map(Self.formatJournal).joined(separator: "\n\n")
            )
        }

        appendSection("Watering", Self.careSectionBody(summary: wateringSummaryLine, lines: wateringLines))
        appendSection("Fertilizing", Self.careSectionBody(summary: fertilizingSummaryLine, lines: fertilizingLines))

        var repotBody: [String] = []
        if let currentPotLine, !currentPotLine.isEmpty {
            repotBody.append(currentPotLine)
        }
        repotBody.append(contentsOf: repottingLines)
        appendSection("Repotting", repotBody.joined(separator: "\n"))

        if !developmentPhotos.isEmpty {
            let photoBody = developmentPhotos.map { photo in
                let date = photo.date.formatted(date: .abbreviated, time: .omitted)
                let name = photo.name.trimmingCharacters(in: .whitespacesAndNewlines)
                return name.isEmpty ? date : "\(date) — \(name)"
            }.joined(separator: "\n")
            appendSection("Development", photoBody)
        }

        if !timelineEvents.isEmpty {
            appendSection(
                "Timeline",
                timelineEvents.map(Self.formatTimeline).joined(separator: "\n")
            )
        }

        appendSection("Notes", notes)

        if !wroteSection {
            parts.append("No history recorded yet.")
        }

        return parts.joined(separator: "\n")
    }

    static func assemble(
        tree: Tree,
        identityLines: [String],
        acquisitionLines: [String],
        yamadoriLines: [String],
        journalEntries: [JournalEntry],
        wateringSummaryLine: String?,
        wateringLines: [String],
        fertilizingSummaryLine: String?,
        fertilizingLines: [String],
        currentPotLine: String?,
        repottingLines: [String],
        developmentPhotos: [TreeHistoryPhoto],
        timelineEvents: [TreeTimelineEvent],
        notes: String
    ) -> TreeHistoryDocument {
        TreeHistoryDocument(
            title: TreePresentation.title(for: tree),
            identityLines: identityLines,
            acquisitionLines: acquisitionLines,
            yamadoriLines: yamadoriLines,
            knownHistory: tree.knownHistory.trimmingCharacters(in: .whitespacesAndNewlines),
            journalBefore: journalEntries.filter(\.isBeforeOwnership),
            journalDuring: journalEntries.filter { !$0.isBeforeOwnership },
            wateringSummaryLine: wateringSummaryLine,
            wateringLines: wateringLines,
            fertilizingSummaryLine: fertilizingSummaryLine,
            fertilizingLines: fertilizingLines,
            currentPotLine: currentPotLine,
            repottingLines: repottingLines,
            developmentPhotos: developmentPhotos,
            timelineEvents: timelineEvents.filter { $0.kind != .journal && $0.kind != .photo },
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    private static func careSectionBody(summary: String?, lines: [String]) -> String {
        var parts: [String] = []
        if let summary, !summary.isEmpty {
            parts.append(summary)
        }
        parts.append(contentsOf: lines)
        return parts.joined(separator: "\n")
    }

    private static func formatJournal(_ entry: JournalEntry) -> String {
        let date = entry.recordedAt.formatted(date: .abbreviated, time: .omitted)
        let flag = entry.isBeforeOwnership ? " (before ownership)" : ""
        return "\(date)\(flag)\n\(entry.text)"
    }

    private static func formatTimeline(_ event: TreeTimelineEvent) -> String {
        let date = event.date.formatted(date: .abbreviated, time: .omitted)
        if let detail = event.detail, !detail.isEmpty {
            return "\(date) — \(event.headline): \(detail)"
        }
        return "\(date) — \(event.headline)"
    }
}
