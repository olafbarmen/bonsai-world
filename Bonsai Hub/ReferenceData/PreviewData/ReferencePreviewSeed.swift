//
//  ReferencePreviewSeed.swift
//  Bonsai World
//
//  Shared helpers for Lists-worksheet PreviewData seeds.
//  Source: Documentation/Project/bonsai_registry_ultimate.xlsx → "Lists"
//

import Foundation

enum ReferencePreviewSeed {
    /// Stable UUIDs so preview identity stays consistent across launches.
    static func id(list: Int, n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", list, n))!
    }

    static func names(list: Int, _ names: [String]) -> [(id: UUID, name: String, sortOrder: Int)] {
        names.enumerated().map { index, name in
            (id: id(list: list, n: index + 1), name: name, sortOrder: index + 1)
        }
    }
}
