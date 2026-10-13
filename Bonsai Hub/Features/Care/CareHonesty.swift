//
//  CareHonesty.swift
//  Bonsai World
//
//  Honest product lines for Care pages — engines vs Task/Work tracking only.
//

import SwiftUI

enum CareHonesty {
    /// Pages without a Care recommendation engine (Repotting, Health, and generic fallback).
    static let trackingOnlyLine =
        "Task and Work tracking only — no Care recommendation engine on this page."

    /// Care → Seasonal Care — lists only, no season advice.
    static let seasonalTrackingLine =
        "Lists Seasonal Tasks and Work only — this page does not recommend what to do by season."

    /// Care → Today — overview only; Tasks owns the day.
    static let todayTrackingLine =
        "Lists today’s Tasks only — use Tasks → Today for the full day list. No Care advice engine here."

    /// Pages with a live recommendation engine (Watering, Fertilizing, Winter, Spring, Placement).
    static let recommendationActiveLine =
        "Care recommendation engine is active here, alongside Task and Work tracking."
}

struct CareHonestyLine: View {
    let text: String

    var body: some View {
        Text(text)
            .font(FaloTypography.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
