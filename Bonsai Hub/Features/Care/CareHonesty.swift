//
//  CareHonesty.swift
//  Bonsai World
//
//  Honest product lines for Care pages — engines vs Task/Work tracking only.
//

import SwiftUI

enum CareHonesty {
    /// Pages without a Care recommendation engine (Repotting, Health, Seasonal, Today, Placement, Winter).
    static let trackingOnlyLine =
        "Task and Work tracking only — no Care recommendation engine on this page."

    /// Pages with a live recommendation engine (Watering, Fertilizing).
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
