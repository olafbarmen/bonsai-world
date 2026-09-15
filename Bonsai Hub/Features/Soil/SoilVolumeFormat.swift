//
//  SoilVolumeFormat.swift
//  Bonsai World
//

import Foundation

enum SoilVolumeFormat {
    static func liters(_ value: Double) -> String {
        if value.rounded() == value {
            return "\(Int(value)) L"
        }
        return String(format: "%.1f L", value)
    }

    static func bags(_ value: Double) -> String {
        if value.rounded() == value {
            return "\(Int(value))"
        }
        return String(format: "%.1f", value)
    }

    static func signedLiters(_ value: Double) -> String {
        let formatted = liters(abs(value))
        if value > 0 { return "+\(formatted)" }
        if value < 0 { return "−\(formatted)" }
        return formatted
    }
}
