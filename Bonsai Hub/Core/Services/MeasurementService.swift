//
//  MeasurementService.swift
//  Bonsai World
//
//  Shared linear measurement conversion for every Falo World module.
//  Storage: millimetres. Display: Metric (cm / mm by role) or Imperial (in).
//  Trees, Pots, Inventory, Workshop, Reports, and Economy must use this service.
//

import Foundation

/// How a linear value is shown (not how it is stored).
enum LinearMeasurementRole: String, Sendable {
    /// Tree / pot height — Metric: cm · Imperial: in
    case height
    /// Crown, nebari, pot length/width — Metric: cm · Imperial: in
    case width
    /// Trunk / pot / wire diameters — Metric: mm · Imperial: in
    case diameter
}

/// Catalog of measurement dimensions. Add cases without changing conversion APIs.
enum MeasurementDimension: String, CaseIterable, Sendable {
    // Tree
    case height
    case crownWidth
    case nebariWidth
    case trunkDiameter
    // Pot
    case potLength
    case potWidth
    case potHeight
    case potDiameter
    // Future
    case soilVolume
    case wireDiameter
    case deadwoodLength
    case branchDiameter
    case rootSpread

    /// Linear display role when this dimension is a length. `nil` for non-linear (e.g. volume).
    var linearRole: LinearMeasurementRole? {
        switch self {
        case .height, .potHeight, .deadwoodLength:
            .height
        case .crownWidth, .nebariWidth, .potLength, .potWidth, .rootSpread:
            .width
        case .trunkDiameter, .potDiameter, .wireDiameter, .branchDiameter:
            .diameter
        case .soilVolume:
            nil
        }
    }
}

/// Single conversion / formatting entry point for measurements.
enum MeasurementService {
    static let millimetresPerCentimetre: Decimal = 10
    static let millimetresPerInch: Decimal = Decimal(string: "25.4")!

    /// Unit abbreviation for the role under the given system (never dual-stored).
    static func unitLabel(
        role: LinearMeasurementRole,
        system: MeasurementSystem
    ) -> String {
        switch (system, role) {
        case (.metric, .height), (.metric, .width):
            "cm"
        case (.metric, .diameter):
            "mm"
        case (.imperial, _):
            "in"
        }
    }

    static func unitLabel(
        dimension: MeasurementDimension,
        system: MeasurementSystem
    ) -> String {
        guard let role = dimension.linearRole else { return "" }
        return unitLabel(role: role, system: system)
    }

    /// Formats millimetres for display, e.g. `42 cm`, `38 mm`, `16.5 in`.
    static func string(
        millimetres: Int?,
        role: LinearMeasurementRole,
        system: MeasurementSystem,
        empty: String = FaloDisplayValue.empty
    ) -> String {
        guard let millimetres else { return empty }
        let value = displayValue(millimetres: millimetres, role: role, system: system)
        return "\(formatDisplayNumber(value, role: role, system: system)) \(unitLabel(role: role, system: system))"
    }

    static func string(
        millimetres: Int?,
        dimension: MeasurementDimension,
        system: MeasurementSystem,
        empty: String = FaloDisplayValue.empty
    ) -> String {
        guard let role = dimension.linearRole else { return empty }
        return string(millimetres: millimetres, role: role, system: system, empty: empty)
    }

    /// Numeric edit string without unit suffix.
    static func editableNumericString(
        millimetres: Int?,
        role: LinearMeasurementRole,
        system: MeasurementSystem
    ) -> String {
        guard let millimetres else { return "" }
        let value = displayValue(millimetres: millimetres, role: role, system: system)
        return formatDisplayNumber(value, role: role, system: system)
    }

    /// Parses display-unit text into millimetres.
    static func millimetres(
        fromDisplayText raw: String,
        role: LinearMeasurementRole,
        system: MeasurementSystem
    ) -> Int? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        guard let display = Decimal(string: normalized) else { return nil }

        let mm: Decimal
        switch (system, role) {
        case (.metric, .height), (.metric, .width):
            mm = display * millimetresPerCentimetre
        case (.metric, .diameter):
            mm = display
        case (.imperial, _):
            mm = display * millimetresPerInch
        }
        return Int((mm as NSDecimalNumber).doubleValue.rounded())
    }

    static func millimetres(
        fromDisplayText raw: String,
        dimension: MeasurementDimension,
        system: MeasurementSystem
    ) -> Int? {
        guard let role = dimension.linearRole else { return nil }
        return millimetres(fromDisplayText: raw, role: role, system: system)
    }

    // MARK: - Private

    private static func displayValue(
        millimetres: Int,
        role: LinearMeasurementRole,
        system: MeasurementSystem
    ) -> Decimal {
        let mm = Decimal(millimetres)
        switch (system, role) {
        case (.metric, .height), (.metric, .width):
            return mm / millimetresPerCentimetre
        case (.metric, .diameter):
            return mm
        case (.imperial, _):
            return mm / millimetresPerInch
        }
    }

    private static func formatDisplayNumber(
        _ value: Decimal,
        role: LinearMeasurementRole,
        system: MeasurementSystem
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        // Metric diameters are whole millimetres; other displays allow one fraction.
        if system == .metric, role == .diameter {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 1
        }
        return formatter.string(from: value as NSDecimalNumber)
            ?? NSDecimalNumber(decimal: value).stringValue
    }
}

