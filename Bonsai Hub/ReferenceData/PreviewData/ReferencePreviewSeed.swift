//
//  ReferencePreviewSeed.swift
//  Bonsai World
//
//  Shared helpers for Lists-worksheet PreviewData seeds.
//  Source: Documentation/Project/bonsai_registry_ultimate.xlsx → "Lists"
//

import CryptoKit
import Foundation

enum ReferencePreviewSeed {
    /// Namespace for name-stable botanical IDs (genus / species / cultivar).
    /// Reordering or inserting Lists rows must not change these IDs.
    static let botanicalNamespace = UUID(uuidString: "10000000-0000-4000-8000-B07A010A1001")!

    /// Index-stable UUIDs for non-botanical lists (Style, Pot, Status, …).
    static func id(list: Int, n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", list, n))!
    }

    /// Name-stable UUID for botanical records. Same list + name → same ID across regenerations.
    static func id(list: Int, named name: String) -> UUID {
        uuidV5(namespace: botanicalNamespace, name: "\(list):\(normalized(name))")
    }

    static func names(list: Int, _ names: [String]) -> [(id: UUID, name: String, sortOrder: Int)] {
        names.enumerated().map { index, name in
            (id: id(list: list, n: index + 1), name: name, sortOrder: index + 1)
        }
    }

    static func normalized(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// RFC 4122 UUID version 5 (SHA-1). Matches Python `uuid.uuid5`.
    static func uuidV5(namespace: UUID, name: String) -> UUID {
        var namespaceBytes = namespace.uuid
        var data = Data()
        withUnsafeBytes(of: &namespaceBytes) { data.append(contentsOf: $0) }
        data.append(contentsOf: name.utf8)

        let digest = Insecure.SHA1.hash(data: data)
        var bytes = Array(digest)
        bytes[6] = (bytes[6] & 0x0F) | 0x50
        bytes[8] = (bytes[8] & 0x3F) | 0x80

        return UUID(
            uuid: (
                bytes[0], bytes[1], bytes[2], bytes[3],
                bytes[4], bytes[5], bytes[6], bytes[7],
                bytes[8], bytes[9], bytes[10], bytes[11],
                bytes[12], bytes[13], bytes[14], bytes[15]
            )
        )
    }
}
