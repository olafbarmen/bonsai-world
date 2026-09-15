//
//  FaloTypography.swift
//  Bonsai World
//
//  Shared typography roles for Falo application shells.
//

import SwiftUI

/// Semantic type roles aligned with the Falo Design System.
/// Native macOS system fonts only — no custom typefaces.
enum FaloTypography {
    /// Page title (module chrome) — not marketing display.
    static let pageTitle: Font = .title2
    /// Supporting line under a page title.
    static let pageSubtitle: Font = .body
    /// Section heading within a page.
    static let sectionHeading: Font = .headline
    /// Card or list row title.
    static let cardRowTitle: Font = .system(size: 13, weight: .semibold, design: .default)
    /// Primary numeric / metric value (≤ ~28pt).
    static let primaryValue: Font = .system(size: 28, weight: .semibold, design: .default)
    static let body: Font = .body
    /// Supporting / secondary body.
    static let supporting: Font = .body
    /// Caption / metadata.
    static let caption: Font = .caption

    /// Alias — section headings in denser chrome.
    static let headline: Font = sectionHeading

    /// Dashboard greeting and other page-level welcomes only — not a general page title.
    static let greeting: Font = .system(size: 28, weight: .semibold, design: .default)

    /// Large metric on a stat tile (alias of primaryValue).
    static var displayNumber: Font { primaryValue }

    /// Label under a display number.
    static let displayLabel: Font = .system(size: 13, weight: .medium, design: .default)
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
