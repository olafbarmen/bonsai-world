//
//  SeedBatchQuickActionCommand.swift
//  Bonsai World
//
//  Platform-independent commands from Context Tools → Seed Batch Detail.
//

import Foundation

enum SeedBatchQuickActionCommand: String, Hashable, Sendable {
    case startStratification
    case skipToReadyToSow
    case completeCurrentPhase
    case extendPhase
    case changeTime
    case recordSowing
    case recordGermination
    case updateSurvival
    case separateSeedlings
    case createTrees
    case markFailed
}

/// One-shot request so SwiftUI can observe distinct enqueues of the same command.
struct SeedBatchQuickActionRequest: Hashable, Sendable, Identifiable {
    let id: UUID
    let command: SeedBatchQuickActionCommand

    init(command: SeedBatchQuickActionCommand) {
        self.id = UUID()
        self.command = command
    }
}
