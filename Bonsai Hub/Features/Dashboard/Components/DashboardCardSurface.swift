//
//  DashboardCardSurface.swift
//  Bonsai World
//
//  Dashboard card chrome — Falo raised surface (shared tokens).
//

import SwiftUI

enum DashboardCardSurface {
    static var fill: Color { BonsaiWorldColors.raisedSurface }
    static var border: Color { BonsaiWorldColors.border }
    static var shadowColor: Color { FaloShadow.color }
    static var shadowRadius: CGFloat { FaloShadow.radius }
    static var shadowY: CGFloat { FaloShadow.y }
    static var cornerRadius: CGFloat { FaloSurface.cornerRadius }
}

extension View {
    /// Identical elevation chrome for every Dashboard card.
    func dashboardCardChrome() -> some View {
        faloRaisedSurface()
    }
}
