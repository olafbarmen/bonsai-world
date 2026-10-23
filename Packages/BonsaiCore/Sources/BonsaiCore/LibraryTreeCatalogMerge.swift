//
//  LibraryTreeCatalogMerge.swift
//  BonsaiCore
//
//  iCloud sync policy: last-write-wins per Tree by ``Tree/modifiedDate``.
//  Never blind-replace the whole catalog from one device’s memory.
//

import Foundation

enum LibraryTreeCatalogMerge: Sendable {
    /// Merges a proposed catalog with what is already on disk.
    ///
    /// - Newer (or equal) `modifiedDate` on a proposed tree wins for that id.
    /// - Trees only on disk are kept.
    /// - Trees only in `proposed` are added.
    static func merge(disk: [Tree], proposed: [Tree]) -> [Tree] {
        var byID = Dictionary(uniqueKeysWithValues: disk.map { ($0.id, $0) })
        for tree in proposed {
            if let existing = byID[tree.id] {
                if tree.modifiedDate >= existing.modifiedDate {
                    byID[tree.id] = tree
                }
            } else {
                byID[tree.id] = tree
            }
        }

        var ordered: [Tree] = []
        var seen = Set<UUID>()
        for tree in proposed {
            guard let merged = byID[tree.id], !seen.contains(merged.id) else { continue }
            ordered.append(merged)
            seen.insert(merged.id)
        }
        for tree in disk where !seen.contains(tree.id) {
            if let merged = byID[tree.id] {
                ordered.append(merged)
                seen.insert(merged.id)
            }
        }
        return ordered
    }
}
