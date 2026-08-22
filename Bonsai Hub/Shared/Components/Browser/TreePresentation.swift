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

    /// Optional nickname when set.
    static func nicknameIfPresent(for tree: Tree) -> String? {
        let trimmed = tree.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
