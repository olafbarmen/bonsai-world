//
//  ActionDefinition.swift
//  Bonsai World
//
//  Shared Quick Action metadata for Falo application shells.
//

import Foundation

/// Whether an action can run now, is deferred, or is temporarily unavailable.
enum ActionAvailability: Hashable, Sendable {
    case available
    case comingSoon
    case disabled(reason: String?)
}

/// Declarative description of one Quick Action. Worlds supply catalogs; shell UI renders them.
struct ActionDefinition: Identifiable, Hashable, Sendable {
    let id: String
    var title: String
    var systemImage: String?
    var availability: ActionAvailability
    var help: String?

    init(
        id: String,
        title: String,
        systemImage: String? = nil,
        availability: ActionAvailability = .available,
        help: String? = nil
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.availability = availability
        self.help = help
    }

    var isEnabled: Bool {
        if case .disabled = availability { return false }
        return true
    }

    var resolvedHelp: String {
        switch availability {
        case .available:
            return help ?? title
        case .comingSoon:
            if let help, !help.isEmpty {
                return "\(help) — Coming soon"
            }
            return "Coming soon"
        case .disabled(let reason):
            if let reason, !reason.isEmpty {
                return "Unavailable: \(reason)"
            }
            return "Unavailable"
        }
    }
}
