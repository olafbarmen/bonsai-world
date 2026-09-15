//
//  TreeTimelineEvent.swift
//  Bonsai World
//
//  Presentation model for Tree Timeline — assembled from Work, Measurement, Photo,
//  and Journal registrations. Timeline is a consumer; it does not own these records.
//

import Foundation

enum TreeTimelineEventKind: String, Hashable, Sendable {
    case work
    case measurement
    case photo
    case journal
}

/// One chronological row on the Tree Timeline.
struct TreeTimelineEvent: Identifiable, Hashable, Sendable {
    var id: UUID
    var kind: TreeTimelineEventKind
    var date: Date
    var headline: String
    var detail: String?
    var systemImage: String

    /// Newest first. Stable tie-break on id.
    static func sortedChronologically(_ events: [TreeTimelineEvent]) -> [TreeTimelineEvent] {
        events.sorted { lhs, rhs in
            if lhs.date != rhs.date {
                return lhs.date > rhs.date
            }
            return lhs.id.uuidString > rhs.id.uuidString
        }
    }
}

enum TreeTimelineAssembler {
    /// Builds a unified Timeline from existing Tree registrations.
    static func events(
        workRecords: [WorkRecord],
        workTypeName: (UUID) -> String?,
        measurements: [TreeMeasurementRecord],
        measurementDetail: (TreeMeasurementRecord) -> String?,
        photoEvents: [(id: UUID, date: Date, name: String)],
        journalEntries: [JournalEntry] = []
    ) -> [TreeTimelineEvent] {
        var events: [TreeTimelineEvent] = []

        for record in workRecords {
            let headline: String
            if let raw = record.shapingAreaID, let area = ShapingAreaID(rawValue: raw) {
                headline = area.title
            } else {
                headline = workTypeName(record.workTypeID) ?? "Work"
            }
            var detailParts: [String] = []
            if record.shapingAreaID != nil, let typeName = workTypeName(record.workTypeID) {
                detailParts.append(typeName)
            }
            let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
            if !notes.isEmpty {
                detailParts.append(notes)
            }
            events.append(
                TreeTimelineEvent(
                    id: record.id,
                    kind: .work,
                    date: record.performedAt,
                    headline: headline,
                    detail: detailParts.isEmpty ? nil : detailParts.joined(separator: " · "),
                    systemImage: record.shapingAreaID == nil ? "wrench.and.screwdriver" : "leaf"
                )
            )
        }

        for record in measurements {
            let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
            var detailParts: [String] = []
            if let dims = measurementDetail(record), !dims.isEmpty {
                detailParts.append(dims)
            }
            if !notes.isEmpty {
                detailParts.append(notes)
            }
            events.append(
                TreeTimelineEvent(
                    id: record.id,
                    kind: .measurement,
                    date: record.measuredAt,
                    headline: "Measurement",
                    detail: detailParts.isEmpty ? nil : detailParts.joined(separator: " · "),
                    systemImage: "ruler"
                )
            )
        }

        for photo in photoEvents {
            let trimmed = photo.name.trimmingCharacters(in: .whitespacesAndNewlines)
            events.append(
                TreeTimelineEvent(
                    id: photo.id,
                    kind: .photo,
                    date: photo.date,
                    headline: "Photo",
                    detail: trimmed.isEmpty ? nil : trimmed,
                    systemImage: "photo"
                )
            )
        }

        for entry in journalEntries {
            let trimmed = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
            events.append(
                TreeTimelineEvent(
                    id: entry.id,
                    kind: .journal,
                    date: entry.recordedAt,
                    headline: entry.isBeforeOwnership ? "Journal (before ownership)" : "Journal",
                    detail: trimmed.isEmpty ? nil : trimmed,
                    systemImage: "book"
                )
            )
        }

        return TreeTimelineEvent.sortedChronologically(events)
    }
}
