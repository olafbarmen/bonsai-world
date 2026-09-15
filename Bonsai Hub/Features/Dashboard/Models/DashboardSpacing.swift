//
//  DashboardSpacing.swift
//  Bonsai World
//
//  Dashboard grid rhythm — aliases onto FaloSpacing.
//

import CoreGraphics

enum DashboardSpacing {
    /// Between Dashboard sections/cards — calm density (not sparse).
    static let cardGap: CGFloat = FaloSpacing.large
    static let pageInset: CGFloat = FaloSpacing.xxLarge
    static let cardPadding: CGFloat = FaloSpacing.large
    static let titleToContent: CGFloat = FaloSpacing.medium
}
