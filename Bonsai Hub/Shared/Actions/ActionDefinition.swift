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

/// How a catalog row is rendered in Quick Actions.
enum ActionDefinitionKind: Hashable, Sendable {
    /// Tappable action or menu.
    case action
    /// Quiet horizontal rule between groups.
    case separator
    /// Non-interactive group label (Tree / Register / Navigate).
    case sectionHeader
}

/// Declarative description of one Quick Action. Worlds supply catalogs; shell UI renders them.
struct ActionDefinition: Identifiable, Hashable, Sendable {
    let id: String
    var title: String
    var systemImage: String?
    var availability: ActionAvailability
    var help: String?
    /// When non-empty, the row is a menu and these items fire instead of the parent.
    var children: [ActionDefinition]
    var kind: ActionDefinitionKind

    init(
        id: String,
        title: String,
        systemImage: String? = nil,
        availability: ActionAvailability = .available,
        help: String? = nil,
        children: [ActionDefinition] = [],
        kind: ActionDefinitionKind = .action
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.availability = availability
        self.help = help
        self.children = children
        self.kind = kind
    }

    /// Quiet divider between Context Tools groups.
    static func separator(id: String) -> ActionDefinition {
        ActionDefinition(
            id: id,
            title: "",
            availability: .disabled(reason: nil),
            kind: .separator
        )
    }

    /// Non-interactive group label above a Context Tools cluster.
    static func sectionHeader(id: String, title: String) -> ActionDefinition {
        ActionDefinition(
            id: id,
            title: title,
            availability: .disabled(reason: nil),
            kind: .sectionHeader
        )
    }

    var hasMenu: Bool { kind == .action && !children.isEmpty }

    var isEnabled: Bool {
        guard kind == .action else { return false }
        if case .disabled = availability { return false }
        return true
    }

    var resolvedHelp: String {
        switch kind {
        case .separator, .sectionHeader:
            return ""
        case .action:
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
}
