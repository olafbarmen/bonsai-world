//
//  TreeStatusPreviewData.swift
//  Bonsai World
//
//  Lists worksheet → section "Status".
//

import Foundation

enum TreeStatusPreviewData {
    static let all: [TreeStatus] = ReferencePreviewSeed.names(list: 8, [
        "Frøplante",
        "Stikling",
        "Ungplante",
        "Prebonsai",
        "Under utvikling",
        "Bonsai",
        "Ferdig bonsai",
    ]).map { TreeStatus(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
