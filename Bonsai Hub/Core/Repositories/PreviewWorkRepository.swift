//
//  PreviewWorkRepository.swift
//  Bonsai World
//
//  WorkRepository backed by an in-memory array only.
//  Used before a Library is open (first launch) and for SwiftUI #Preview fixtures —
//  not the runtime store once a library is ready. Work has no legacy UserDefaults
//  data to migrate, so there is nothing to seed here beyond an empty session.
//

import Foundation
import Observation

/// In-memory `WorkRepository` for previews and pre-library sessions.
@Observable
@MainActor
final class PreviewWorkRepository: WorkRepository {
    private var records: [WorkRecord]

    init(records: [WorkRecord] = []) {
        self.records = records
    }

    func getAllWork() -> [WorkRecord] {
        records
    }

    func getWork(id: UUID) -> WorkRecord? {
        records.first { $0.id == id }
    }

    @discardableResult
    func createWork(_ record: WorkRecord) throws -> WorkRecord {
        guard !records.contains(where: { $0.id == record.id }) else {
            throw WorkRepositoryError.invalidWork("A work record with this id already exists.")
        }
        records.append(record)
        return record
    }

    @discardableResult
    func updateWork(_ record: WorkRecord) throws -> WorkRecord {
        guard let index = records.firstIndex(where: { $0.id == record.id }) else {
            throw WorkRepositoryError.notFound(record.id)
        }
        records[index] = record
        return record
    }

    func deleteWork(id: UUID) throws {
        guard records.contains(where: { $0.id == id }) else {
            throw WorkRepositoryError.notFound(id)
        }
        records.removeAll { $0.id == id }
    }
}
