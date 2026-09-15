//
//  SoilGrainSize.swift
//  Bonsai World
//
//  Structured particle-size band for soil stock. Presets cover common grades;
//  Custom stores explicit min/max millimetres for later filtering.
//

import Foundation

enum SoilGrainSizeBand: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case under1mm
    case from1to2mm
    case from2to4mm
    case from4to6mm
    case from6to8mm
    case from8to12mm
    case custom

    var id: Self { self }

    var title: String {
        switch self {
        case .under1mm: "< 1 mm"
        case .from1to2mm: "1–2 mm"
        case .from2to4mm: "2–4 mm"
        case .from4to6mm: "4–6 mm"
        case .from6to8mm: "6–8 mm"
        case .from8to12mm: "8–12 mm"
        case .custom: "Custom"
        }
    }

    var defaultMinimumMillimetres: Double {
        switch self {
        case .under1mm: 0
        case .from1to2mm: 1
        case .from2to4mm: 2
        case .from4to6mm: 4
        case .from6to8mm: 6
        case .from8to12mm: 8
        case .custom: 0
        }
    }

    var defaultMaximumMillimetres: Double {
        switch self {
        case .under1mm: 1
        case .from1to2mm: 2
        case .from2to4mm: 4
        case .from4to6mm: 6
        case .from6to8mm: 8
        case .from8to12mm: 12
        case .custom: 0
        }
    }
}

/// Structured grain size on a stock line (never free text only).
struct SoilGrainSize: Hashable, Codable, Sendable {
    var band: SoilGrainSizeBand
    var minimumMillimetres: Double
    var maximumMillimetres: Double
    /// Optional note (shape, angularity) — not a substitute for min/max.
    var particleNotes: String

    init(
        band: SoilGrainSizeBand = .from2to4mm,
        minimumMillimetres: Double? = nil,
        maximumMillimetres: Double? = nil,
        particleNotes: String = ""
    ) {
        self.band = band
        self.minimumMillimetres = minimumMillimetres ?? band.defaultMinimumMillimetres
        self.maximumMillimetres = maximumMillimetres ?? band.defaultMaximumMillimetres
        self.particleNotes = particleNotes
    }

    var displayTitle: String {
        if band == .custom {
            return "\(format(minimumMillimetres))–\(format(maximumMillimetres)) mm"
        }
        return band.title
    }

    var isValid: Bool {
        minimumMillimetres >= 0 && maximumMillimetres >= minimumMillimetres
    }

    mutating func applyBand(_ band: SoilGrainSizeBand) {
        self.band = band
        if band != .custom {
            minimumMillimetres = band.defaultMinimumMillimetres
            maximumMillimetres = band.defaultMaximumMillimetres
        }
    }

    private func format(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(format: "%.1f", value)
    }
}
