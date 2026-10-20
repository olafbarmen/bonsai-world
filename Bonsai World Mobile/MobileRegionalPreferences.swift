//
//  MobileRegionalPreferences.swift
//  Bonsai World
//
//  Regional display prefs for iOS — same UserDefaults keys as Mac AppSettings
//  (measurement + currency). Values stay millimetres / Decimal; this only affects labels.
//

import Foundation
import Observation

enum MobileMeasurementSystem: String, CaseIterable, Identifiable, Hashable, Sendable {
    case metric
    case imperial

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .metric: "Metric (SI)"
        case .imperial: "Imperial (US)"
        }
    }
}

enum MobileAppCurrency: String, CaseIterable, Identifiable, Hashable, Sendable {
    case nok, sek, dkk, eur, gbp, usd, cad, aud, jpy, chf

    var id: String { rawValue }

    var code: String { rawValue.uppercased() }

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

    var menuTitle: String { "\(code) – \(name)" }
}

enum MobileLinearMeasurementRole: Sendable {
    case height
    case width
    case diameter
}

/// Shared with Mac `falo.appSettings.*` keys so a future shared container can align.
@Observable
@MainActor
final class MobileRegionalPreferences {
    private static let currencyKey = "falo.appSettings.currencyCode"
    private static let measurementSystemKey = "falo.appSettings.measurementSystem"

    static let shared = MobileRegionalPreferences()

    var currency: MobileAppCurrency {
        didSet {
            guard currency != oldValue else { return }
            UserDefaults.standard.set(currency.rawValue, forKey: Self.currencyKey)
        }
    }

    var measurementSystem: MobileMeasurementSystem {
        didSet {
            guard measurementSystem != oldValue else { return }
            UserDefaults.standard.set(measurementSystem.rawValue, forKey: Self.measurementSystemKey)
        }
    }

    private init() {
        currency = UserDefaults.standard.string(forKey: Self.currencyKey)
            .flatMap(MobileAppCurrency.init)
            ?? .nok
        measurementSystem = UserDefaults.standard.string(forKey: Self.measurementSystemKey)
            .flatMap(MobileMeasurementSystem.init)
            ?? .metric
    }

    static func unitLabel(role: MobileLinearMeasurementRole, system: MobileMeasurementSystem) -> String {
        switch (system, role) {
        case (.metric, .height), (.metric, .width): "cm"
        case (.metric, .diameter): "mm"
        case (.imperial, _): "in"
        }
    }

    static func millimetres(
        fromDisplayText raw: String,
        role: MobileLinearMeasurementRole,
        system: MobileMeasurementSystem
    ) -> Int? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        guard let display = Decimal(string: normalized) else { return nil }
        let mm: Decimal
        switch (system, role) {
        case (.metric, .height), (.metric, .width):
            mm = display * 10
        case (.metric, .diameter):
            mm = display
        case (.imperial, _):
            mm = display * Decimal(string: "25.4")!
        }
        return Int((mm as NSDecimalNumber).doubleValue.rounded())
    }
}
