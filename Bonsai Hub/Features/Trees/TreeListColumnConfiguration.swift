//
//  TreeListColumnConfiguration.swift
//  Bonsai World
//
//  User preferences for which Tree List columns are visible and in what order.
//  Persists choices; Settings will drive this later — Tree List only reads it.
//

import Foundation
import Observation

/// Show/hide and reorder configuration for the Trees data grid.
@Observable
@MainActor
final class TreeListColumnConfiguration {
    private static let storageKey = "falo.treeList.visibleColumnIDs"

    /// Ordered list of currently visible columns (required identity always included).
    /// Prefer `setVisible` / `reorder(to:)` so order stays normalized.
    var visibleColumnIDs: [TreeListColumnID] {
        didSet {
            guard visibleColumnIDs != oldValue else { return }
            persist()
        }
    }

    init(visibleColumnIDs: [TreeListColumnID]? = nil) {
        if let visibleColumnIDs {
            self.visibleColumnIDs = Self.normalized(visibleColumnIDs)
        } else if let stored = Self.loadStored() {
            self.visibleColumnIDs = stored
        } else {
            self.visibleColumnIDs = TreeListColumnID.defaultOrder
        }
    }

    // MARK: - Settings-facing API (no UI yet)

    func isVisible(_ columnID: TreeListColumnID) -> Bool {
        visibleColumnIDs.contains(columnID)
    }

    /// Show or hide a column. Required columns cannot be hidden.
    func setVisible(_ columnID: TreeListColumnID, _ visible: Bool) {
        if columnID.isRequired { return }

        var next = visibleColumnIDs
        if visible {
            guard !next.contains(columnID) else { return }
            // Insert using default relative order among visible columns.
            next.append(columnID)
        } else {
            next.removeAll { $0 == columnID }
        }
        visibleColumnIDs = Self.normalized(next)
    }

    /// Replace order of visible columns. Missing required identity is restored.
    func reorder(to orderedIDs: [TreeListColumnID]) {
        visibleColumnIDs = Self.normalized(orderedIDs)
    }

    /// Toggleable columns for a future Settings pane (excludes required identity).
    var toggleableColumnIDs: [TreeListColumnID] {
        TreeListColumnID.defaultOrder.filter { !$0.isRequired }
    }

    // MARK: - Persistence

    private func persist() {
        let raw = visibleColumnIDs.map(\.rawValue)
        UserDefaults.standard.set(raw, forKey: Self.storageKey)
    }

    private static func loadStored() -> [TreeListColumnID]? {
        guard let raw = UserDefaults.standard.array(forKey: storageKey) as? [String] else {
            return nil
        }
        let decoded = raw.compactMap(TreeListColumnID.init(rawValue:))
        guard !decoded.isEmpty else { return nil }
        return normalized(decoded)
    }

    /// Ensures botanical name is first among required, drops unknowns/duplicates,
    /// and keeps a stable order for any IDs that appear.
    private static func normalized(_ ids: [TreeListColumnID]) -> [TreeListColumnID] {
        var seen = Set<TreeListColumnID>()
        var result: [TreeListColumnID] = []

        for id in ids where seen.insert(id).inserted {
            result.append(id)
        }

        if !result.contains(.botanicalName) {
            result.insert(.botanicalName, at: 0)
        } else if result.first != .botanicalName {
            result.removeAll { $0 == .botanicalName }
            result.insert(.botanicalName, at: 0)
        }

        return result
    }
}
