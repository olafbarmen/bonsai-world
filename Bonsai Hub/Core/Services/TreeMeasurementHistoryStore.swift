//
//  TreeMeasurementHistoryStore.swift
//  Bonsai World
//
//  Append-only Measurement History for Trees.
//  Persists to Database/TreeMeasurementHistory.json in the library package.
//

import Foundation
import Observation

@Observable
@MainActor
final class TreeMeasurementHistoryStore {
    private(set) var file = TreeMeasurementHistoryFile()
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
        reload()
    }

    func reload() {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.treeMeasurementHistoryFileName
            ) else {
                file = TreeMeasurementHistoryFile()
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            file = try decoder.decode(TreeMeasurementHistoryFile.self, from: data)
        } catch {
            file = TreeMeasurementHistoryFile()
        }
    }

    /// All records for a tree, oldest Measurement Date first.
    func records(for treeID: UUID) -> [TreeMeasurementRecord] {
        file.records
            .filter { $0.treeID == treeID }
            .sorted { lhs, rhs in
                if lhs.measuredAt != rhs.measuredAt {
                    return lhs.measuredAt < rhs.measuredAt
                }
                return lhs.createdDate < rhs.createdDate
            }
    }

    /// Latest measurement session for a tree, if any.
    func latest(for treeID: UUID) -> TreeMeasurementRecord? {
        records(for: treeID).last
    }

    /// All sessions, newest Measurement Date first (current measurement first).
    func timeline(for treeID: UUID) -> [TreeMeasurementRecord] {
        Array(records(for: treeID).reversed())
    }

    /// Previous sessions only (excludes latest), newest Measurement Date first.
    func previous(for treeID: UUID) -> [TreeMeasurementRecord] {
        let all = records(for: treeID)
        guard all.count > 1 else { return [] }
        return Array(all.dropLast().reversed())
    }

    /// Seeds history from Tree fields once when history is empty and values exist.
    @discardableResult
    func ensureMigrated(from tree: Tree) -> TreeMeasurementRecord? {
        let existing = records(for: tree.id)
        if let latest = existing.last {
            return latest
        }
        let seed = TreeMeasurementRecord.fromLatestFields(
            on: tree,
            measuredAt: tree.modifiedDate
        )
        guard seed.hasAnyValue else { return nil }
        append(seed)
        return seed
    }

    /// Appends a new historical record. Never updates or deletes prior records.
    func append(_ record: TreeMeasurementRecord) {
        file.records.append(record)
        persist()
    }

    private func persist() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(file)
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.treeMeasurementHistoryFileName,
                data: data
            )
        } catch {
            // Best-effort persistence.
        }
    }
}
