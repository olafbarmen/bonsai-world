//
//  YamadoriIDService.swift
//  BonsaiCore
//
//  Allocates immutable YAM-YYYY-NNN codes for Finds. Separate from Tree Bonsai Name sequences.
//

import Foundation

enum YamadoriIDService {
    /// Formats `YAM-2026-024` (year + zero-padded sequence).
    static func format(year: Int, sequence: Int) -> String {
        String(format: "YAM-%04d-%03d", year, sequence)
    }

    static func parse(_ code: String) -> (year: Int, sequence: Int)? {
        let parts = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().split(separator: "-")
        guard parts.count == 3, parts[0] == "YAM",
              let year = Int(parts[1]), parts[1].count == 4,
              let sequence = Int(parts[2]), sequence > 0
        else { return nil }
        return (year, sequence)
    }

    /// Next sequence for calendar year, given existing Find codes.
    static func nextCode(year: Int = Calendar.current.component(.year, from: .now), existing: [YamadoriFind]) -> String {
        let used = existing.compactMap { parse($0.yamadoriCode) }
            .filter { $0.year == year }
            .map(\.sequence)
        let next = (used.max() ?? 0) + 1
        return format(year: year, sequence: next)
    }
}
