//
//  FaloDisplayValue.swift
//  Bonsai World
//
//  Shared presentation for optional / empty user-facing values.
//  Never show None, nil, or null in the UI — use a dash.
//

import Foundation

/// Formats optional strings for display. One helper for every Falo World UI.
enum FaloDisplayValue {
    /// Placeholder shown when a value has not been entered.
    static let empty = "-"

    /// Returns the trimmed value, or ``empty`` when nil / blank.
    static func text(_ value: String?, empty: String = FaloDisplayValue.empty) -> String {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? empty : trimmed
    }

    /// Convenience for non-optional strings that may still be blank.
    static func text(_ value: String, empty: String = FaloDisplayValue.empty) -> String {
        text(Optional(value), empty: empty)
    }
}
