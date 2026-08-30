//
//  ContextQuickActionsCatalog.swift
//  Bonsai World
//
//  World-specific Context Quick Actions per AppRoute (Architecture Version 2).
//  Trees: context depends on selection + View/Edit mode. Add Tree is Global only.
//

import Foundation

enum ContextQuickActionsCatalog {
    static let newCollectionID = "context.collection.newCollection"
    static let addTreeToCollectionID = "context.collection.addTree"
    static let editCollectionID = "context.collection.editCollection"
    static let finishCollectionEditID = "context.collection.finish"
    static let newLocationID = "context.locations.newLocation"
    static let cropPhotoID = "context.media.cropPhoto"

    // Trees — view (tree selected)
    static let editTreeID = "context.trees.editTree"
    static let addImageID = "context.trees.addImage"
    static let viewImagesID = "context.trees.viewImages"
    static let showOnMapID = "context.trees.showOnMap"
    static let duplicateTreeID = "context.trees.duplicateTree"
    static let deleteTreeID = "context.trees.deleteTree"
    static let returnToCareID = "context.trees.returnToCare"
    static let addMeasurementID = "context.trees.addMeasurement"
    static let addToFavoriteTreesID = "context.trees.addToFavoriteTrees"
    static let removeFromFavoriteTreesID = "context.trees.removeFromFavoriteTrees"

    // Trees — edit mode (Auto Save; Finish leaves Edit Mode — standard for future editors)
    static let cancelTreeEditID = "context.trees.cancel"

    /// Context for Trees Quick Actions (selection + interaction mode).
    struct TreesContext: Hashable, Sendable {
        var selectedTreeID: UUID?
        var interactionMode: TreeDetailInteractionMode
        /// Former Trees (not in care) are view-only — no Edit / Add Image.
        var isInCare: Bool = true
        var isFavorite: Bool = false

        static let none = TreesContext(selectedTreeID: nil, interactionMode: .viewing, isInCare: true, isFavorite: false)
    }

    /// Context for Collections Quick Actions (selection + interaction mode).
    struct CollectionsContext: Hashable, Sendable {
        var selectedCollectionID: UUID?
        var selectedCollectionIsManual: Bool
        var interactionMode: TreeDetailInteractionMode

        static let none = CollectionsContext(
            selectedCollectionID: nil,
            selectedCollectionIsManual: false,
            interactionMode: .viewing
        )
    }

    /// Placeholder / module actions for the selected route.
    static func actions(
        for section: AppRoute?,
        treesContext: TreesContext = .none,
        collectionsContext: CollectionsContext = .none,
        mediaSelectedImageID: UUID? = nil
    ) -> [ActionDefinition] {
        guard let section else { return [] }

        switch section {
        case .dashboard:
            return [
                placeholder(id: "context.dashboard.continueWorking", title: "Continue Working", systemImage: "play.fill"),
                placeholder(id: "context.dashboard.viewTodaysTasks", title: "View Today's Tasks", systemImage: "checklist")
            ]

        case .tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear:
            return []

        case .locationsPlaces, .locationsMap, .locationsGardens:
            return [
                ActionDefinition(
                    id: ContextQuickActionsCatalog.newLocationID,
                    title: "New Location",
                    systemImage: "mappin.and.ellipse",
                    availability: .available,
                    help: "Create a Location in Reference Data"
                ),
                placeholder(id: "context.locations.viewStatistics", title: "View Statistics", systemImage: "chart.bar")
            ]

        case .gardenCollections:
            return collectionsActions(collectionsContext)

        case .gardenTrees:
            return treesActions(treesContext)

        case .mediaImages:
            return mediaImagesActions(selectedImageID: mediaSelectedImageID)

        case .workshopWork:
            return [
                placeholder(id: "context.work.logWork", title: "Log Work", systemImage: "plus.circle"),
                placeholder(id: "context.work.batchWork", title: "Batch Work", systemImage: "square.stack.3d.up")
            ]

        case .workshopCalendar:
            return [
                placeholder(id: "context.calendar.addEvent", title: "Add Event", systemImage: "calendar.badge.plus")
            ]

        case .workshopTasks:
            return [
                placeholder(id: "context.tasks.newTask", title: "New Task", systemImage: "checklist")
            ]

        case .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
             .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment:
            return [
                placeholder(id: "context.nursery.newItem", title: "New Nursery Item", systemImage: "leaf.arrow.triangle.circlepath"),
                placeholder(id: "context.nursery.addTask", title: "Add Task", systemImage: "checklist")
            ]

        case .settings:
            return []

        default:
            return []
        }
    }

    private static func mediaImagesActions(selectedImageID: UUID?) -> [ActionDefinition] {
        [
            placeholder(id: "context.media.importPhotos", title: "Import Photos", systemImage: "photo.badge.plus"),
            ActionDefinition(
                id: cropPhotoID,
                title: "Crop",
                systemImage: "crop",
                availability: selectedImageID == nil
                    ? .disabled(reason: "Select an image first")
                    : .available,
                help: "Crop the display of this photo. The original file is not changed."
            )
        ]
    }

    private static func collectionsActions(_ context: CollectionsContext) -> [ActionDefinition] {
        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: finishCollectionEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            var actions: [ActionDefinition] = [
                ActionDefinition(
                    id: newCollectionID,
                    title: "New Collection",
                    systemImage: "plus.square.on.square",
                    availability: .available,
                    help: "Create an organizational group of trees"
                )
            ]
            guard context.selectedCollectionID != nil else { return actions }

            if context.selectedCollectionIsManual {
                actions.append(
                    ActionDefinition(
                        id: addTreeToCollectionID,
                        title: "Add Existing Tree",
                        systemImage: "leaf",
                        availability: .available,
                        help: "Add existing trees to this collection"
                    )
                )
            }
            actions.append(
                ActionDefinition(
                    id: editCollectionID,
                    title: "Edit Collection",
                    systemImage: "pencil",
                    availability: .available,
                    help: "Edit this collection’s name, description, icon, and color"
                )
            )
            return actions
        }
    }

    private static func treesActions(_ context: TreesContext) -> [ActionDefinition] {
        guard context.selectedTreeID != nil else { return [] }

        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: cancelTreeEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            var actions: [ActionDefinition] = []
            if context.isInCare {
                actions.append(contentsOf: [
                    ActionDefinition(
                        id: editTreeID,
                        title: "Edit Tree",
                        systemImage: "pencil",
                        availability: .available,
                        help: "Edit this tree’s details"
                    ),
                    ActionDefinition(
                        id: addImageID,
                        title: "Add Image",
                        systemImage: "photo.badge.plus",
                        availability: .available,
                        help: "Add a primary image for this tree"
                    ),
                    ActionDefinition(
                        id: duplicateTreeID,
                        title: "Duplicate Tree Info",
                        systemImage: "plus.square.on.square",
                        availability: .available,
                        help: "New Bonsai Name; botanics, placement, pot, and acquisition from this tree"
                    )
                ])
            }
            if !context.isInCare {
                actions.append(
                    ActionDefinition(
                        id: returnToCareID,
                        title: "Return to My Trees",
                        systemImage: "arrow.uturn.backward",
                        availability: .available,
                        help: "Clear disposal and put this tree back in My Trees"
                    )
                )
            }
            if context.isFavorite {
                actions.append(
                    ActionDefinition(
                        id: removeFromFavoriteTreesID,
                        title: "Remove from Favorite Trees",
                        systemImage: "star.slash",
                        availability: .available,
                        help: "Remove this tree from Favorite Trees"
                    )
                )
            } else {
                actions.append(
                    ActionDefinition(
                        id: addToFavoriteTreesID,
                        title: "Add to Favorite Trees",
                        systemImage: "star",
                        availability: .available,
                        help: "Add this tree to Favorite Trees"
                    )
                )
            }
            actions.append(contentsOf: [
                ActionDefinition(
                    id: showOnMapID,
                    title: "Show on Map",
                    systemImage: "map",
                    availability: .available,
                    help: "Open the Garden map at this tree’s Location"
                ),
                ActionDefinition(
                    id: viewImagesID,
                    title: "View Images",
                    systemImage: "photo.on.rectangle.angled",
                    availability: .available,
                    help: "Open Images in Media for this tree"
                ),
                ActionDefinition(
                    id: deleteTreeID,
                    title: "Delete Tree",
                    systemImage: "trash",
                    availability: .available,
                    help: "Remove a mistaken or duplicate record — not for sold, gifted, dead, or lost trees"
                )
            ])
            return actions
        }
    }

    private static func placeholder(
        id: String,
        title: String,
        systemImage: String
    ) -> ActionDefinition {
        ActionDefinition(
            id: id,
            title: title,
            systemImage: systemImage,
            availability: .comingSoon,
            help: title
        )
    }
}
