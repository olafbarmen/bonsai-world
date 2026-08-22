//
//  DashboardCardSurface.swift
//  Bonsai World
//
//  Shared Dashboard card chrome — identical depth on every card.
//

import SwiftUI

enum DashboardCardSurface {
    static var fill: Color {
        #if os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color.primary.opacity(0.04)
        #endif
    }

    static let border = Color.primary.opacity(0.06)
    static let shadowColor = Color.black.opacity(0.045)
    static let shadowRadius: CGFloat = 2.5
    static let shadowY: CGFloat = 1
    static let cornerRadius: CGFloat = FaloRadius.large
}

extension View {
    /// Identical elevation chrome for every Dashboard card.
    func dashboardCardChrome() -> some View {
        self
            .background {
                RoundedRectangle(cornerRadius: DashboardCardSurface.cornerRadius, style: .continuous)
                    .fill(DashboardCardSurface.fill)
                    .shadow(
                        color: DashboardCardSurface.shadowColor,
                        radius: DashboardCardSurface.shadowRadius,
                        x: 0,
                        y: DashboardCardSurface.shadowY
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: DashboardCardSurface.cornerRadius, style: .continuous)
                    .strokeBorder(DashboardCardSurface.border, lineWidth: 1)
            }
    }
}
