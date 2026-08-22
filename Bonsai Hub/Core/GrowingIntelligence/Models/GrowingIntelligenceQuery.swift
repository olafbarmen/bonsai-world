//
//  GrowingIntelligenceQuery.swift
//  Bonsai World
//
//  Identity-only input for a Growing Intelligence evaluation.
//  Engines resolve live facts from owning modules — no duplicated payloads.
//

import Foundation

/// Query identities for a Growing Intelligence pass.
///
/// Consumes (read-only, via owning services — not stored here):
/// - Trees: species, stage, health, soil, pot, roots, repot history
/// - Habitat: garden, location environment (sun, shade, wind, rain, humidity, …)
/// - Workshop: care history / future work signals
/// - Weather (future): current, forecast, history, wind, humidity, UV
/// - Reference Data: fertilizers, soil components, species, growing profiles
struct GrowingIntelligenceQuery: Hashable, Sendable {
    var treeID: UUID?
    var locationID: UUID?
    var gardenID: UUID?
    /// Evaluation moment. Engines may later use this for seasonal rules.
    var asOf: Date

    init(
        treeID: UUID? = nil,
        locationID: UUID? = nil,
        gardenID: UUID? = nil,
        asOf: Date = .now
    ) {
        self.treeID = treeID
        self.locationID = locationID
        self.gardenID = gardenID
        self.asOf = asOf
    }
}
