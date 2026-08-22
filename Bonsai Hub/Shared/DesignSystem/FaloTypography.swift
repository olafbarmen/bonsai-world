//
//  FaloTypography.swift
//  Bonsai World
//
//  Shared typography roles for Falo application shells.
//

import SwiftUI

/// Semantic type roles aligned with the Falo Design System.
enum FaloTypography {
    static let headline: Font = .headline
    static let body: Font = .body
    static let caption: Font = .caption
}

// MARK: - Falo Card Typography Standard v1

/// Fixed typography for informational Detail cards (Tree Detail and future Falo Worlds).
/// Hierarchy: section title → field label → value.
enum FaloCardTypography {
    /// Section marker (e.g. IDENTITY) — 13 pt semibold, secondary, tracked caps.
    static let sectionTitle: Font = .system(size: 13, weight: .semibold)
    static let sectionTitleTracking: CGFloat = 1.2

    /// Field label (e.g. Nickname) — 16 pt regular, secondary.
    static let fieldLabel: Font = .system(size: 16, weight: .regular)

    /// Field value — 16 pt medium, primary (empty values stay secondary).
    static let fieldValue: Font = .system(size: 16, weight: .medium)

    /// Extra space under the section title before the first field (≈ 6–8 pt beyond base).
    static let titleToContentExtra: CGFloat = 8

    /// Total spacing from card title to first row (medium + extra).
    static var titleToContent: CGFloat { FaloSpacing.medium + titleToContentExtra }
}
