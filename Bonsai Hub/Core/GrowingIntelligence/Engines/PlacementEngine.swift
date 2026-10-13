//
//  PlacementEngine.swift
//  Bonsai World
//
//  Growing Intelligence — Placement Engine v1 (AJ1 gaps only).
//  Uses Placement strategy + Season + whether Location resolves.
//  Never invents a destination Location. Never changes Tasks or Work.
//

import Foundation

struct PlacementEngine: GrowingIntelligenceEngine, Sendable {
    let engineID = "growingIntelligence.placement"

    /// Gap kinds for one In Care tree.
    func gaps(
        for tree: Tree,
        hasResolvedLocation: Bool,
        winterCareActive: Bool,
        springCareActive: Bool
    ) -> [PlacementGapKind] {
        guard tree.isInCare else { return [] }

        var kinds: [PlacementGapKind] = []
        if !hasResolvedLocation {
            kinds.append(.missingLocation)
        }
        if tree.placementStrategy == .seasonal {
            if winterCareActive, tree.seasonPlacement == .summer {
                kinds.append(.shouldMoveToWinter)
            }
            if springCareActive, tree.seasonPlacement == .winter {
                kinds.append(.shouldMoveToSummer)
            }
        }
        return kinds
    }

    /// All gap items for In Care trees, sorted by title then kind order.
    func advice(
        trees: [Tree],
        title: (Tree) -> String,
        hasResolvedLocation: (Tree) -> Bool,
        winterCareActive: Bool,
        springCareActive: Bool
    ) -> PlacementAdvice {
        let kindOrder = Dictionary(
            uniqueKeysWithValues: PlacementGapKind.allCases.enumerated().map { ($1, $0) }
        )
        var items: [PlacementAdviceItem] = []
        for tree in trees where tree.isInCare {
            let gaps = gaps(
                for: tree,
                hasResolvedLocation: hasResolvedLocation(tree),
                winterCareActive: winterCareActive,
                springCareActive: springCareActive
            )
            let treeTitle = title(tree)
            for kind in gaps {
                items.append(
                    PlacementAdviceItem(treeID: tree.id, treeTitle: treeTitle, kind: kind)
                )
            }
        }
        items.sort {
            let titleCmp = $0.treeTitle.localizedCaseInsensitiveCompare($1.treeTitle)
            if titleCmp != .orderedSame { return titleCmp == .orderedAscending }
            return (kindOrder[$0.kind] ?? 0) < (kindOrder[$1.kind] ?? 0)
        }
        return PlacementAdvice(items: items)
    }
}
