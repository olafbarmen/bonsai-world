//
//  AppCurrency.swift
//  Bonsai World
//
//  Global currency preference for Falo Worlds.
//  Numeric amounts stay on domain models; formatting is Settings-controlled.
//  No conversion / exchange rates — display preference only.
//

import Foundation

/// Supported display currencies (ISO 4217 codes).
enum AppCurrency: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case nok
    case sek
    case dkk
    case eur
    case gbp
    case usd
    case cad
    case aud
    case jpy
    case chf

    var id: String { rawValue }

    /// ISO currency code (e.g. `NOK`).
    var code: String { rawValue.uppercased() }

    /// Human-readable currency name.
    var name: String {
        switch self {
        case .nok: "Norwegian Krone"
        case .sek: "Swedish Krona"
        case .dkk: "Danish Krone"
        case .eur: "Euro"
        case .gbp: "British Pound"
        case .usd: "US Dollar"
        case .cad: "Canadian Dollar"
        case .aud: "Australian Dollar"
        case .jpy: "Japanese Yen"
        case .chf: "Swiss Franc"
        }
    }

    /// Settings menu label: `NOK – Norwegian Krone`.
    var menuTitle: String { "\(code) – \(name)" }
}

/// Formats stored numeric amounts using the global currency preference.
enum CurrencyFormatting {
    /// Formats an optional amount for display. Empty / nil → `empty`.
    static func string(
        _ amount: Decimal?,
        currency: AppCurrency,
        empty: String = FaloDisplayValue.empty
    ) -> String {
        guard let amount else { return empty }
        return string(amount, currency: currency)
    }

    /// Formats a non-optional amount for display.
    static func string(_ amount: Decimal, currency: AppCurrency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.code
        formatter.locale = .current
        return formatter.string(from: amount as NSDecimalNumber)
            ?? "\(NSDecimalNumber(decimal: amount).stringValue) \(currency.code)"
    }

    /// Plain numeric string for editing (no currency symbol).
    static func editableNumericString(_ amount: Decimal?) -> String {
        guard let amount else { return "" }
        return NSDecimalNumber(decimal: amount).stringValue
    }

    /// Parses user-entered numeric text into a Decimal (commas accepted as decimal separators).
    static func parseAmount(_ raw: String) -> Decimal? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }
}
