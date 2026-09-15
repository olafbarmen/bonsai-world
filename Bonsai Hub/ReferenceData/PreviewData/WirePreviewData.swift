//
//  WirePreviewData.swift
//  Bonsai World
//
//  Reference Data seed for Wire — Alu and Copper, 0.5–8 mm in 0.5 steps.
//  Inventory → Wire stock picks these catalog rows by ID.
//

import Foundation

enum WirePreviewData {
    /// Lists-worksheet style list index reserved for Wire catalog rows.
    private static let listIndex = 16

    private static let materials = ["Alu", "Copper"]

    /// 0.5, 1, 1.5, … 8
    private static let diametersMM: [Double] = stride(from: 0.5, through: 8.0, by: 0.5).map { $0 }

    static let all: [Wire] = {
        var rows: [Wire] = []
        var sortOrder = 1
        for material in materials {
            for diameter in diametersMM {
                let name = "\(material) \(formatDiameter(diameter)) mm"
                rows.append(
                    Wire(
                        id: ReferencePreviewSeed.id(list: listIndex, n: sortOrder),
                        name: name,
                        sortOrder: sortOrder
                    )
                )
                sortOrder += 1
            }
        }
        return rows
    }()

    private static func formatDiameter(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(format: "%.1f", value)
    }
}
