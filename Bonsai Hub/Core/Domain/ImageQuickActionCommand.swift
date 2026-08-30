//
//  ImageQuickActionCommand.swift
//  Bonsai World
//
//  Image Tools commands for Image Workspace (Context Tools §7.2).
//

import Foundation

enum ImageQuickActionCommand: String, Hashable, Sendable {
    case importPhotos
    case attachToTree
    case crop
    case rotate
    case setPrimary
    case setFeatured
    case compare
    case delete
}

struct ImageQuickActionRequest: Hashable, Sendable, Identifiable {
    var id: String { command.rawValue }
    let command: ImageQuickActionCommand

    init(command: ImageQuickActionCommand) {
        self.command = command
    }
}
