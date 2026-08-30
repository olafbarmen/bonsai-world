//
//  GlobalQuickActionsCatalog.swift
//  Bonsai World
//
//  World-specific Global Quick Actions (always visible).
//  Consumed by QuickActionsView — do not hardcode these inside the view.
//

import Foundation

enum GlobalQuickActionsCatalog {
    static let addTreeMenuID = "global.addTreeMenu"
    static let newTreeID = "global.newTree"
    static let copyExistingTreeID = "global.copyExistingTree"
    static let searchID = "global.search"
    static let importID = "global.import"

    /// Canonical global Quick Actions (sidebar order).
    static var actions: [ActionDefinition] {
        [
            ActionDefinition(
                id: addTreeMenuID,
                title: "Add Tree",
                systemImage: "leaf",
                availability: .available,
                help: "Add a blank tree or duplicate tree info from an existing one",
                children: [
                    ActionDefinition(
                        id: newTreeID,
                        title: "New Tree",
                        systemImage: "leaf",
                        availability: .available,
                        help: "Add a tree from a blank form"
                    ),
                    ActionDefinition(
                        id: copyExistingTreeID,
                        title: "Duplicate Tree Info",
                        systemImage: "plus.square.on.square",
                        availability: .available,
                        help: "New Bonsai Name; botanics, placement, pot, and acquisition from a tree in My Trees"
                    )
                ]
            ),
            ActionDefinition(
                id: searchID,
                title: "Search",
                systemImage: "magnifyingglass",
                availability: .comingSoon,
                help: "Find trees, places, and notes"
            ),
            ActionDefinition(
                id: importID,
                title: "Import",
                systemImage: "square.and.arrow.down",
                availability: .comingSoon,
                help: "Bring data into Bonsai World"
            )
        ]
    }
}
