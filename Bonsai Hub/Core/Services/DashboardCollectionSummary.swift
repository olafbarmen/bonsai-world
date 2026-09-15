//
//  DashboardCollectionSummary.swift
//  Bonsai World
//
//  Dashboard My Trees aggregation (Blueprint §5.1 — whole-library counts).
//  Pure, stateless functions over Trees + Reference Data — Dashboard aggregates
//  read-only signals; it never owns Tree, Genus, Species, TreeStage, or
//  AcquisitionMethod records. Views call these functions; they never compute
//  counts or classify status themselves (Constitution §14 — one owner per rule).
//
//  Same functions run on macOS, Windows, and iPhone — no UI or platform import.
//

import Foundation

enum DashboardCollectionSummary {

    // MARK: - Hero metrics (Collection column)

    struct Metric: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let count: Int
    }

    /// Tree Stage names counted as finished / mature trees.
    private static let finishedStageNames = [
        "refinement", "exhibition", "ferdig bonsai", "finished bonsai", "finished",
    ]
    /// Tree Stage names counted as development trees.
    static let developmentStageNames = [
        "seedling", "cutting", "nursery stock", "pre-bonsai", "prebonsai",
        "in training", "under utvikling", "in development", "development",
    ]
    /// Acquisition Method name counted as Yamadori origin (Blueprint §4.4).
    private static let yamadoriAcquisitionNames = ["yamadori"]

    /// Stage IDs that count as Development — same rule as the Dashboard metric.
    static func developmentStageIDs(in treeStages: [TreeStage]) -> Set<UUID> {
        matchingIDs(in: treeStages, exactNames: developmentStageNames)
    }

    /// Whether a tree is in care and tagged with a Development Tree Stage.
    static func isDevelopmentTree(_ tree: Tree, developmentStageIDs: Set<UUID>) -> Bool {
        guard tree.isInCare else { return false }
        guard let stageID = tree.treeStageID else { return false }
        return developmentStageIDs.contains(stageID)
    }

    /// Column 1 — In Care / Finished / Development / Yamadori / Without Stage,
    /// then Died / Sold (always) and other disposal outcomes when count > 0.
    /// Care buckets count only trees still in care (no disposal method).
    static func heroMetrics(
        trees: [Tree],
        treeStages: [TreeStage],
        acquisitionMethods: [AcquisitionMethod],
        disposalMethods: [DisposalMethod]
    ) -> [Metric] {
        let inCare = trees.filter(\.isInCare)
        let activeStageIDs = Set(treeStages.map(\.id))
        let finishedStageIDs = matchingIDs(in: treeStages, exactNames: finishedStageNames)
        let developmentStageIDs = matchingIDs(in: treeStages, exactNames: developmentStageNames)
        let yamadoriMethodIDs = matchingIDs(in: acquisitionMethods, exactNames: yamadoriAcquisitionNames)

        let finishedCount = inCare.count { $0.treeStageID.map(finishedStageIDs.contains) == true }
        let developmentCount = inCare.count { $0.treeStageID.map(developmentStageIDs.contains) == true }
        let yamadoriCount = inCare.count { $0.acquisitionMethodID.map(yamadoriMethodIDs.contains) == true }
        let withoutStageCount = inCare.count { tree in
            guard let stageID = tree.treeStageID else { return true }
            return !activeStageIDs.contains(stageID)
        }

        var metrics: [Metric] = [
            Metric(id: "inCare", label: "My Trees", count: inCare.count),
            Metric(id: "finished", label: "Finished Bonsai", count: finishedCount),
            Metric(id: "development", label: "Development Trees", count: developmentCount),
            Metric(id: "yamadori", label: "Yamadori", count: yamadoriCount),
            Metric(id: "withoutStage", label: "Without Stage", count: withoutStageCount),
        ]

        metrics.append(contentsOf: disposalOutcomeMetrics(trees: trees, disposalMethods: disposalMethods))
        return metrics
    }

    // MARK: - Species breakdown (Species column)

    struct SpeciesBreakdown: Identifiable, Hashable, Sendable {
        let id: UUID
        let name: String
        let count: Int
    }

    /// Dominant Species (falling back to Genus when a Tree has no Species set),
    /// most common first. Names are Reference Data as authored — no invented labels.
    static func speciesBreakdown(
        trees: [Tree],
        genus: [Genus],
        species: [Species],
        limit: Int = 14
    ) -> [SpeciesBreakdown] {
        let genusByID = Dictionary(uniqueKeysWithValues: genus.map { ($0.id, $0) })
        let speciesByID = Dictionary(uniqueKeysWithValues: species.map { ($0.id, $0) })

        var counts: [UUID: Int] = [:]
        var labels: [UUID: String] = [:]

        for tree in trees {
            let key: UUID
            let label: String
            if let speciesID = tree.speciesID, let match = speciesByID[speciesID] {
                key = speciesID
                label = match.name
            } else if let genusID = tree.genusID, let match = genusByID[genusID] {
                key = genusID
                label = match.name
            } else {
                continue
            }
            counts[key, default: 0] += 1
            labels[key] = label
        }

        return counts
            .compactMap { id, count -> SpeciesBreakdown? in
                guard let name = labels[id] else { return nil }
                return SpeciesBreakdown(id: id, name: name, count: count)
            }
            .sorted { lhs, rhs in
                if lhs.count != rhs.count { return lhs.count > rhs.count }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
            .prefix(limit)
            .map { $0 }
    }

    // MARK: - Library gaps (Dashboard Library → Garden Trees filters)

    /// Same photo rule as Needs Photos / Trees ``withoutPhoto`` — ``Tree/lacksPhoto``.
    static func lacksPhoto(_ tree: Tree) -> Bool {
        tree.lacksPhoto
    }

    /// Missing Tree Stage assignment (Library “Without status”).
    static func lacksTreeStage(_ tree: Tree) -> Bool {
        tree.treeStageID == nil
    }

    /// Missing Species reference (Library “Without species”).
    static func lacksSpecies(_ tree: Tree) -> Bool {
        tree.speciesID == nil
    }

    /// In-care Garden trees — same base as Garden → Trees list (excludes Yamadori nursery).
    static func gardenTreesInCare(from trees: [Tree]) -> [Tree] {
        trees.filter { $0.isInCare && !$0.yamadoriNursery }
    }

    static func libraryGapCount(in trees: [Tree], matching predicate: (Tree) -> Bool) -> Int {
        gardenTreesInCare(from: trees).count(where: predicate)
    }

    // MARK: - Private

    /// Died and Sold always appear so the dashboard updates as ownership ends.
    /// Other outcomes only when at least one tree has that method.
    private static func disposalOutcomeMetrics(
        trees: [Tree],
        disposalMethods: [DisposalMethod]
    ) -> [Metric] {
        let outcomeByMethodID = Dictionary(
            uniqueKeysWithValues: disposalMethods.map { ($0.id, $0.outcome) }
        )
        var counts: [DisposalOutcome: Int] = [:]
        for tree in trees {
            guard let methodID = tree.disposalMethodID,
                  let outcome = outcomeByMethodID[methodID]
            else { continue }
            counts[outcome, default: 0] += 1
        }

        let alwaysShown: [DisposalOutcome] = [.died, .sold]
        let extras = DisposalOutcome.allCases.filter { outcome in
            !alwaysShown.contains(outcome) && (counts[outcome] ?? 0) > 0
        }
        return (alwaysShown + extras).map { outcome in
            Metric(
                id: "disposal.\(outcome.rawValue)",
                label: outcome.dashboardLabel,
                count: counts[outcome] ?? 0
            )
        }
    }

    private static func matchingIDs<Item: ReferenceListItem>(
        in items: [Item],
        exactNames: [String]
    ) -> Set<UUID> {
        Set(
            items
                .filter { item in exactNames.contains { $0.caseInsensitiveCompare(item.name) == .orderedSame } }
                .map(\.id)
        )
    }
}
