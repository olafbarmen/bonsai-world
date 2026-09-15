//
//  PotQuickActionCommand.swift
//  Bonsai World
//
//  Platform-independent commands from Quick Actions → Pot Detail.
//  Mirrors TreeQuickActionCommand.
//

import Foundation

enum PotQuickActionCommand: String, Hashable, Sendable {
    case editPot
    case addImage
    case markSold
    case markBroken
    case markRetired
    case returnToAvailable
    case deletePot
    case cancel
}

/// One-shot request so SwiftUI can observe distinct enqueues of the same command.
struct PotQuickActionRequest: Hashable, Sendable, Identifiable {
    let id: UUID
    let command: PotQuickActionCommand

    init(command: PotQuickActionCommand) {
        self.id = UUID()
        self.command = command
    }
}

/// Errors for PotService business rules.
enum PotServiceError: Error, LocalizedError, Sendable {
    case potIdentityLocked
    case potNotAvailable
    case treeNotFound

    var errorDescription: String? {
        switch self {
        case .potIdentityLocked:
            return "Pot ID cannot be changed after a pot is created."
        case .potNotAvailable:
            return "That pot is not Available and cannot be assigned to a tree."
        case .treeNotFound:
            return "That tree could not be found."
        }
    }
}
