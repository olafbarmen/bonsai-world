//
//  SeedBatchWorkspaceWindowContext.swift
//  Bonsai World
//
//  Opens a dedicated Seed Batch window (double-click from list).
//

import Foundation

struct SeedBatchWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    var id: UUID { batchID }
    var batchID: UUID

    init(batchID: UUID) {
        self.batchID = batchID
    }
}

extension SeedBatchWorkspaceWindowContext {
    static let windowID = "seed-batch-workspace"
}
