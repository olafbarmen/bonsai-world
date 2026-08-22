//
//  DashboardSpacing.swift
//  Bonsai World
//
//  Dashboard visual grid — one rhythm for margins, gutters, and card chrome.
//

import CoreGraphics

/// Shared Dashboard layout rhythm.
/// Outer margin and card gutters share the same value so the page reads as one grid.
enum DashboardSpacing {
    /// Exact gap between cards in a column (and between the two columns).
    static let cardGap: CGFloat = 24

    /// Alias for clarity at the page edge — always equal to ``cardGap``.
    static let pageInset: CGFloat = cardGap

    /// Identical internal padding for every Dashboard card.
    static let cardPadding: CGFloat = 16

    /// Space between card title and body — identical on every card.
    static let titleToContent: CGFloat = 12
}
