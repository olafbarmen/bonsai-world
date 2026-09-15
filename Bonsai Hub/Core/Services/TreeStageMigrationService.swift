//
//  TreeStageMigrationService.swift
//  Bonsai World
//
//  One-time migration from Tree Status / Development Stage to Tree Stage.
//

import Foundation

@MainActor
enum TreeStageMigrationService {
    private static let completedKey = "bonsai.world.migration.treeStage.v1"

    struct AmbiguousLegacyValue: Sendable, Equatable {
        var treeID: UUID
        var legacyStageID: UUID
        var legacyName: String?
    }

    enum Result: Sendable, Equatable {
        case notRequired
        case migrated(treeCount: Int, remappedCount: Int, ambiguous: [AmbiguousLegacyValue])
        case failed
    }

    static func migrateIfNeeded(
        treeService: TreeService,
        referencePreviewData: ReferencePreviewData
    ) -> Result {
        guard !UserDefaults.standard.bool(forKey: completedKey) else {
            return .notRequired
        }

        referencePreviewData.treeStages = TreeStagePreviewData.all
        referencePreviewData.noteMutation()

        var trees = treeService.getAllTrees()
        var remappedCount = 0
        var ambiguous: [AmbiguousLegacyValue] = []

        for index in trees.indices {
            let originalID = trees[index].treeStageID
            guard let originalID else { continue }

            if TreeStagePreviewData.stage(id: originalID) != nil {
                continue
            }

            let legacyName = TreeStageLegacyCatalog.legacyName(for: originalID)
            if let legacyName,
               let canonical = TreeStageLegacyCatalog.canonicalStageName(fromLegacyName: legacyName),
               let newID = TreeStagePreviewData.id(for: canonical) {
                trees[index].treeStageID = newID
                remappedCount += 1
                continue
            }

            ambiguous.append(
                AmbiguousLegacyValue(
                    treeID: trees[index].id,
                    legacyStageID: originalID,
                    legacyName: legacyName
                )
            )
        }

        do {
            for tree in trees where tree.treeStageID != treeService.getTree(id: tree.id)?.treeStageID {
                _ = try treeService.updateTree(tree)
            }
        } catch {
            return .failed
        }

        UserDefaults.standard.set(true, forKey: completedKey)
        return .migrated(
            treeCount: trees.count,
            remappedCount: remappedCount,
            ambiguous: ambiguous
        )
    }
}
