//
//  TreeCurrentPotDisplay.swift
//  Bonsai World
//
//  Resolves the Tree's visible Current Pot for Overview, lists, and summaries.
//
//  Priority:
//  1. Assigned Inventory Pot (Pot module SSOT)
//  2. Tree Pot Description (Tree.potTypeID + optional dims — not copied from Inventory)
//  3. No pot information
//

import Foundation

enum TreeCurrentPotSource: Hashable, Sendable {
    case inventoryPot
    case treeDescription
    case none
}

struct TreeCurrentPotDisplay: Hashable, Sendable {
    /// Display title for “Pot” rows, or `nil` when nothing to show.
    var title: String?
    var source: TreeCurrentPotSource

    /// Inventory Pot → Tree Pot Description → none.
    @MainActor
    static func resolve(
        tree: Tree,
        potService: PotService,
        referenceData: ReferenceDataService
    ) -> TreeCurrentPotDisplay {
        if let pot = resolvedInventoryPot(for: tree, potService: potService) {
            return TreeCurrentPotDisplay(
                title: inventoryTitle(for: pot, referenceData: referenceData),
                source: .inventoryPot
            )
        }

        if let typeID = tree.potTypeID,
           let name = referenceData.potType(id: typeID)?.name.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty {
            return TreeCurrentPotDisplay(title: name, source: .treeDescription)
        }

        return TreeCurrentPotDisplay(title: nil, source: .none)
    }

    @MainActor
    static func resolvedInventoryPot(for tree: Tree, potService: PotService) -> Pot? {
        if let potID = tree.currentPotID, let pot = potService.getPot(id: potID) {
            return pot
        }
        return potService.pot(linkedToTreeID: tree.id)
    }

    @MainActor
    private static func inventoryTitle(for pot: Pot, referenceData: ReferenceDataService) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if let potTypeID = pot.potTypeID, let type = referenceData.potType(id: potTypeID) {
            return type.name
        }
        return "Untitled Pot"
    }
}
