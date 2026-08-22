//
//  SizeClassPreviewData.swift
//  Bonsai World
//
//  Reference Data — size classes (same seed pattern as Tree Status).
//

import Foundation

enum SizeClassPreviewData {
    static let all: [SizeClass] = ReferencePreviewSeed.names(list: 22, [
        "Mame",
        "Shohin",
        "Kifu",
        "Chuhin",
        "Dai",
        "Imperial",
    ]).map { SizeClass(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
