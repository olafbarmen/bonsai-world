//
//  FaloIconSize.swift
//  Bonsai World
//
//  Semantic SF Symbol sizes for Falo shells. Prefer these over magic numbers.
//

import CoreGraphics

enum FaloIconSize {
    /// Sidebar / navigation chrome.
    static let navigation: CGFloat = 13
    /// Context Tools and similar actions.
    static let action: CGFloat = 14
    /// Inline status indicators.
    static let status: CGFloat = 13
    /// Dashboard / overview metric rows (care categories, etc.).
    static let row: CGFloat = 16
    /// Metric / stat tile icons — clear visual anchors.
    static let metric: CGFloat = 48
    /// Touch target / well around metric icons.
    static let metricWell: CGFloat = 72
    /// General informational icons in content.
    static let informational: CGFloat = 18
    /// Empty-state hero icons only when meaningful.
    static let emptyState: CGFloat = 36
}
