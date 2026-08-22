//
//  CollectionQuickActionCommand.swift
//  Bonsai World
//
//  Platform-independent commands from Quick Actions → Collection Detail.
//  UI adapters enqueue commands; Collection Detail performs them.
//

import Foundation

/// Collection Detail actions requested from Quick Actions (never from duplicate toolbars).
enum CollectionQuickActionCommand: String, Hashable, Sendable {
    case editCollection
    /// Leave Edit Mode after Auto Save (same Finish pattern as Tree Detail).
    case finish
}

/// One-shot request so SwiftUI can observe distinct enqueues of the same command.
struct CollectionQuickActionRequest: Hashable, Sendable, Identifiable {
    let id: UUID
    let command: CollectionQuickActionCommand

    init(command: CollectionQuickActionCommand) {
        self.id = UUID()
        self.command = command
    }
}
