//
//  TreePresentation.swift
//  Bonsai World
//
//  Presentation helpers for Tree domain values.
//  Not part of the Tree model — Views / Features only.
//

import Foundation

enum TreePresentation {
    /// List / related-row title: nickname if set, otherwise botanical name, otherwise bonsai name.
    static func title(for tree: Tree) -> String {
        if let nickname = nicknameIfPresent(for: tree) {
            return nickname
        }
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !botanical.isEmpty { return botanical }
        let bonsai = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !bonsai.isEmpty { return bonsai }
        return "Untitled Tree"
    }

    /// Immutable registry identity (`GEN-SPE-CUL-YYYY-NNN`) — primary in pot assignment and similar pickers.
    static func registryName(for tree: Tree) -> String {
        let bonsai = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !bonsai.isEmpty { return bonsai }
        return title(for: tree)
    }

    /// Secondary line under ``registryName`` — botanical name when present.
    static func registrySubtitle(for tree: Tree) -> String? {
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? nil : botanical
    }

    /// Single-line pot/list label: registry name, then botanical when both exist.
    static func registryLabel(for tree: Tree) -> String {
        let name = registryName(for: tree)
        if let subtitle = registrySubtitle(for: tree), subtitle != name {
            return "\(name) · \(subtitle)"
        }
        return name
    }

    /// Optional nickname when set.
    static func nicknameIfPresent(for tree: Tree) -> String? {
        let trimmed = tree.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
