//
//  TreeQuickActionCommand.swift
//  Bonsai World
//
//  Platform-independent commands from Quick Actions → Tree Detail.
//  UI adapters enqueue commands; Tree Detail performs them.
//

import Foundation

/// Tree Detail actions requested from Quick Actions (never from duplicate toolbars).
enum TreeQuickActionCommand: String, Hashable, Sendable {
    case editTree
    case addImage
    case viewGallery
    case showOnMap
    case duplicateTree
    case deleteTree
    case cancel
    case addMeasurement
}

/// One-shot request so SwiftUI can observe distinct enqueues of the same command.
struct TreeQuickActionRequest: Hashable, Sendable, Identifiable {
    let id: UUID
    let command: TreeQuickActionCommand

    init(command: TreeQuickActionCommand) {
        self.id = UUID()
        self.command = command
    }
}
