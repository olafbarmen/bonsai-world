//
//  LibraryCatalogSyncStamp.swift
//  BonsaiCore
//
//  Sidecar next to Trees.json so iPhone can detect a stale local catalog
//  (e.g. 97 trees) while Mac has already written a larger shared catalog.
//

import Foundation

/// Written whenever the tree catalog is persisted. Read by iPhone before trusting local Trees.json.
struct LibraryCatalogSyncStamp: Codable, Hashable, Sendable {
    var treeCount: Int
    var myTreesCount: Int
    var seasonalSummerCount: Int
    var deviceName: String
    var writtenAt: Date

    init(
        treeCount: Int,
        myTreesCount: Int,
        seasonalSummerCount: Int,
        deviceName: String,
        writtenAt: Date = .now
    ) {
        self.treeCount = treeCount
        self.myTreesCount = myTreesCount
        self.seasonalSummerCount = seasonalSummerCount
        self.deviceName = deviceName
        self.writtenAt = writtenAt
    }

    static func make(from trees: [Tree], deviceName: String, now: Date = .now) -> LibraryCatalogSyncStamp {
        let myTrees = trees.filter { $0.isInCare && !$0.yamadoriNursery }
        let summer = myTrees.filter {
            $0.placementStrategy == .seasonal && $0.seasonPlacement == .summer
        }
        return LibraryCatalogSyncStamp(
            treeCount: trees.count,
            myTreesCount: myTrees.count,
            seasonalSummerCount: summer.count,
            deviceName: deviceName,
            writtenAt: now
        )
    }

    /// Local catalog is behind when it is missing a meaningful number of trees vs the stamp.
    func isLocalCatalogBehind(localTreeCount: Int, slack: Int = 2) -> Bool {
        localTreeCount + slack < treeCount
    }
}

/// Shared Winter Care checklist scope (Mac WinterCareService / mobile CareParity).
enum LibraryWinterCareCatalog: Sendable {
    static func treesNeedingChecklist(
        from trees: [Tree],
        winterCareActive: Bool
    ) -> [Tree] {
        guard winterCareActive else { return [] }
        return trees.filter {
            $0.isInCare
                && !$0.yamadoriNursery
                && $0.placementStrategy == .seasonal
                && $0.seasonPlacement == .summer
                && !Set($0.winterCareCompletedSteps).isSuperset(of: Set(WinterCareStep.allCases))
        }
    }
}
