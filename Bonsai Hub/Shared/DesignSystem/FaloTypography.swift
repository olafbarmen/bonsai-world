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
/// Sized for desktop information density — professional management, not marketing scale.
enum FaloCardTypography {
    /// Section marker (e.g. IDENTITY) — small tracked caps.
    static let sectionTitle: Font = .system(size: 11, weight: .semibold)
    static let sectionTitleTracking: CGFloat = 1.0

    /// Field label (e.g. Nickname) — one step below body, secondary.
    static let fieldLabel: Font = .system(size: 13, weight: .regular)

    /// Field value — same size as label, semibold primary (empty values stay secondary).
    static let fieldValue: Font = .system(size: 13, weight: .semibold)

    /// Extra space under the section title before the first field.
    static let titleToContentExtra: CGFloat = 4

    /// Total spacing from card title to first row (small + extra).
    static var titleToContent: CGFloat { FaloSpacing.small + titleToContentExtra }
}
