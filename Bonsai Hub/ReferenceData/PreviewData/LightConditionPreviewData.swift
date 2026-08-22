//
//  LightConditionPreviewData.swift
//  Bonsai World
//
//  Reference Data — light conditions (same seed pattern as Tree Status).
//

import Foundation

enum LightConditionPreviewData {
    static let all: [LightCondition] = ReferencePreviewSeed.names(list: 10, [
        "Full Sun",
        "Partial Sun",
        "Partial Shade",
        "Bright Indirect",
        "Shade",
        "Indoor Light",
    ]).map { LightCondition(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
