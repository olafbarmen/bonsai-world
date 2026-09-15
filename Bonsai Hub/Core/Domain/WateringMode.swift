//
//  WateringMode.swift
//  Bonsai World
//
//  Watering reminder / auto policy — owned by a Care-policy Collection,
//  optionally overridden on the Tree. Heat watch marks Care Watering on hot days.
//

import Foundation

enum WateringMode: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    /// Include in Care → Watering Due and reminders.
    case remind
    /// Grower waters manually; no Due / reminder.
    case silent
    /// Covered by auto-watering; no Due / reminder.
    case auto

    var id: Self { self }

    var title: String {
        switch self {
        case .remind: "Remind"
        case .silent: "Silent"
        case .auto: "Auto-watered"
        }
    }

    var help: String {
        switch self {
        case .remind: "Show in Tasks and Care → Watering Due."
        case .silent: "No watering reminders — you decide when to water."
        case .auto: "Covered by auto-watering; not listed as due."
        }
    }
}

/// Resolved watering behaviour for one Tree.
struct EffectiveWateringPolicy: Hashable, Sendable {
    var mode: WateringMode
    /// 1…3 when mode is ``WateringMode/auto``.
    var autoTimesPerDay: Int?
    /// When on, Care → Watering shows Heat watch if high heat is forecast.
    var heatWatchEnabled: Bool
    var sourceLabel: String

    static let `default` = EffectiveWateringPolicy(
        mode: .silent,
        autoTimesPerDay: nil,
        heatWatchEnabled: false,
        sourceLabel: "Default (Silent)"
    )
}

enum TreeWateringPolicyResolver {
    static func effective(
        for tree: Tree,
        collections: (UUID) -> Collection?
    ) -> EffectiveWateringPolicy {
        let heatWatch = heatWatchEnabled(for: tree, collections: collections)

        if let mode = tree.wateringModeOverride {
            let times = mode == .auto
                ? clampedTimes(tree.autoTimesPerDayOverride ?? 1)
                : nil
            return EffectiveWateringPolicy(
                mode: mode,
                autoTimesPerDay: times,
                heatWatchEnabled: heatWatch,
                sourceLabel: "Tree override"
            )
        }

        if let collectionID = tree.carePolicyCollectionID,
           let collection = collections(collectionID),
           collection.isCarePolicyCollection {
            return fromCollection(collection)
        }

        return .default
    }

    static func fromCollection(_ collection: Collection) -> EffectiveWateringPolicy {
        let mode = collection.wateringMode
        return EffectiveWateringPolicy(
            mode: mode,
            autoTimesPerDay: mode == .auto ? clampedTimes(collection.autoTimesPerDay) : nil,
            heatWatchEnabled: collection.heatWatchEnabled,
            sourceLabel: "Collection “\(collection.name)”"
        )
    }

    static func clampedTimes(_ value: Int) -> Int {
        min(3, max(1, value))
    }

    /// Heat watch stays on the Care-policy Collection even when mode is overridden on the Tree.
    private static func heatWatchEnabled(
        for tree: Tree,
        collections: (UUID) -> Collection?
    ) -> Bool {
        guard let collectionID = tree.carePolicyCollectionID,
              let collection = collections(collectionID),
              collection.isCarePolicyCollection
        else { return false }
        return collection.heatWatchEnabled
    }
}
