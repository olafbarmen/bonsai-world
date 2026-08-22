//
//  DevelopmentStagePreviewData.swift
//  Bonsai World
//
//  Tree Development stages — starter vocabulary for training progression.
//

import Foundation

enum DevelopmentStagePreviewData {
    static let all: [DevelopmentStage] = ReferencePreviewSeed.names(list: 20, [
        "Seed",
        "Seedling",
        "Cutting",
        "Nursery Stock",
        "Yamadori",
        "Pre-Bonsai",
        "In Training",
        "Refinement",
        "Exhibition",
    ]).map { DevelopmentStage(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
