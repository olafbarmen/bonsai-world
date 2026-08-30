//
//  DashboardCollectionSummary.swift
//  Bonsai World
//
//  Dashboard My Trees aggregation (Blueprint §5.1 — whole-library counts).
//  Pure, stateless functions over Trees + Reference Data — Dashboard aggregates
//  read-only signals; it never owns Tree, Genus, Species, TreeStatus, or
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

    /// Tree Status names counted as "Finished Bonsai" (exact, case-insensitive match —
    /// confirmed with the grower against the real Status taxonomy, not guessed).
    private static let finishedStatusNames = ["bonsai", "ferdig bonsai", "finished bonsai", "finished"]
    /// Tree Status names counted as "Development Trees".
    private static let developmentStatusNames = ["prebonsai", "under utvikling", "in development", "development"]
    /// Acquisition Method name counted as Yamadori origin (Blueprint §4.4).
    private static let yamadoriAcquisitionNames = ["yamadori"]

    /// Column 1 — In Care / Finished / Development / Yamadori / Without Status,
    /// then Died / Sold (always) and other disposal outcomes when count > 0.
    /// Care buckets count only trees still in care (no disposal method).
    static func heroMetrics(
        trees: [Tree],
        treeStatuses: [TreeStatus],
        acquisitionMethods: [AcquisitionMethod],
        disposalMethods: [DisposalMethod]
    ) -> [Metric] {
        let inCare = trees.filter(\.isInCare)
        let activeStatusIDs = Set(treeStatuses.map(\.id))
        let finishedStatusIDs = matchingIDs(in: treeStatuses, exactNames: finishedStatusNames)
        let developmentStatusIDs = matchingIDs(in: treeStatuses, exactNames: developmentStatusNames)
        let yamadoriMethodIDs = matchingIDs(in: acquisitionMethods, exactNames: yamadoriAcquisitionNames)

        let finishedCount = inCare.count { $0.treeStatusID.map(finishedStatusIDs.contains) == true }
        let developmentCount = inCare.count { $0.treeStatusID.map(developmentStatusIDs.contains) == true }
        let yamadoriCount = inCare.count { $0.acquisitionMethodID.map(yamadoriMethodIDs.contains) == true }
        let withoutStatusCount = inCare.count { tree in
            guard let statusID = tree.treeStatusID else { return true }
            return !activeStatusIDs.contains(statusID)
        }

        var metrics: [Metric] = [
            Metric(id: "inCare", label: "My Trees", count: inCare.count),
            Metric(id: "finished", label: "Finished Bonsai", count: finishedCount),
            Metric(id: "development", label: "Development Trees", count: developmentCount),
            Metric(id: "yamadori", label: "Yamadori", count: yamadoriCount),
            Metric(id: "withoutStatus", label: "Without Status", count: withoutStatusCount)
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
