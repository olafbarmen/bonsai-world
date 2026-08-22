//
//  SystemSmartCollections.swift
//  Bonsai World
//
//  Built-in Smart Collection placeholders that establish permanent Collections
//  navigation. Membership rules are not evaluated yet — these records exist for
//  list structure only.
//

import Foundation

/// Stable catalog of system Smart Collections shown under **Smart Collections**.
enum SystemSmartCollections {
    /// Navigation order within the Smart Collections list section.
    static let placeholders: [Placeholder] = [
        Placeholder(
            id: StableID.favoriteTrees,
            name: "Favorite Trees",
            description: "Trees marked as favorites.",
            icon: "star.fill",
            color: "#C4A35A"
        ),
        Placeholder(
            id: StableID.todaysWork,
            name: "Today's Work",
            description: "Trees that need attention today.",
            icon: "sun.max.fill",
            color: "#C4A35A"
        ),
        Placeholder(
            id: StableID.needsWater,
            name: "Needs Water",
            description: "Trees that need watering.",
            icon: "drop.fill",
            color: "#5A6570"
        ),
        Placeholder(
            id: StableID.needsRepotting,
            name: "Needs Repotting",
            description: "Trees due for repotting.",
            icon: "leaf.arrow.circlepath",
            color: "#3D6B5A"
        ),
        Placeholder(
            id: StableID.needsPhotos,
            name: "Needs Photos",
            description: "Trees without a primary photo.",
            icon: "camera.fill",
            color: "#A66A4E"
        ),
    ]

    static var ids: Set<UUID> {
        Set(placeholders.map(\.id))
    }

    static func sortIndex(for id: UUID) -> Int? {
        placeholders.firstIndex { $0.id == id }
    }

    /// Builds Smart Collection records with empty membership (no filter evaluation).
    static func makeCollections(preservingTreeIDs: [UUID: [UUID]] = [:]) -> [Collection] {
        placeholders.map { placeholder in
            Collection(
                id: placeholder.id,
                name: placeholder.name,
                description: placeholder.description,
                type: .smart,
                color: placeholder.color,
                icon: placeholder.icon,
                treeIDs: preservingTreeIDs[placeholder.id] ?? [],
                smartDefinition: SmartCollectionDefinition()
            )
        }
    }

    /// Stable UUIDs for system Smart Collections (prefix 2 matches preview collection namespace).
    enum StableID {
        static let favoriteTrees = uuid(2)
        static let todaysWork = uuid(101)
        static let needsWater = uuid(102)
        static let needsRepotting = uuid(103)
        static let needsPhotos = uuid(104)

        private static func uuid(_ n: Int) -> UUID {
            UUID(uuidString: String(format: "00000000-0000-4000-8002-%012d", n))!
        }
    }

    struct Placeholder: Hashable, Sendable {
        let id: UUID
        let name: String
        let description: String
        let icon: String
        let color: String
    }
}
