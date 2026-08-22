//
//  GrowingIntelligenceEngine.swift
//  Bonsai World
//
//  Shared contract for Growing Intelligence engines.
//  Engines combine SSOT inputs; they never own duplicated domain data.
//

import Foundation

/// Marker protocol for Growing Intelligence engines.
/// Behaviour is intentionally empty until each engine is designed and approved.
protocol GrowingIntelligenceEngine: Sendable {
    /// Stable engine identity for logging / future diagnostics.
    var engineID: String { get }
}
