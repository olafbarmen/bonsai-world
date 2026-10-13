//
//  WinterAdvice.swift
//  Bonsai World
//
//  Advisory output from WinterEngine — info only. Never changes Tasks or Work.
//

import Foundation

struct WinterAdvice: Hashable, Sendable {
    /// Location + weather winter risk lines.
    var lines: [String]

    var hasContent: Bool { !lines.isEmpty }

    static let empty = WinterAdvice(lines: [])
}
