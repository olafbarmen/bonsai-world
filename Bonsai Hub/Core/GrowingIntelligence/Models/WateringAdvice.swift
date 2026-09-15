//
//  WateringAdvice.swift
//  Bonsai World
//
//  Advisory output from WateringEngine — info only. Never changes Tasks,
//  Due dates, or Watering policy frequency.
//

import Foundation

struct WateringAdvice: Hashable, Sendable {
    /// Location + weather risk lines (same spirit as Location Detail / Weather card).
    var lines: [String]
    /// True when Collection Heat watch is on and high heat is forecast.
    var heatWatchActive: Bool

    var hasContent: Bool {
        !lines.isEmpty || heatWatchActive
    }

    static let empty = WateringAdvice(lines: [], heatWatchActive: false)
}
