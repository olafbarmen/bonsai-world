//
//  CropQuickActionCommand.swift
//  Bonsai World
//
//  Crop Tools commands for the Crop Workspace sidebar.
//

import Foundation

enum CropQuickActionCommand: String, Hashable, Sendable {
    case saveCrop
    case resetCrop
    case rotate
    case mirror
    case compareOriginal
    case cancel
}

struct CropQuickActionRequest: Hashable, Sendable, Identifiable {
    var id: String { command.rawValue }
    let command: CropQuickActionCommand

    init(command: CropQuickActionCommand) {
        self.command = command
    }
}
