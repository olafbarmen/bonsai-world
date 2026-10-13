//
//  InventoryWireRollSize.swift
//  BonsaiCore
//
//  Wire stock is counted in rolls of a fixed weight.
//

import Foundation

enum InventoryWireRollSize: Int, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case grams100 = 100
    case grams500 = 500
    case grams1000 = 1000

    var id: Int { rawValue }

    /// Display title using the grower's wording (gr).
    var title: String {
        "\(rawValue) gr"
    }
}
