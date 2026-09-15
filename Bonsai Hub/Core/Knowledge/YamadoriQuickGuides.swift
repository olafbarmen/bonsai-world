//
//  YamadoriQuickGuides.swift
//  Bonsai World
//
//  Reference-data stubs for Yamadori Quick Guides (Blueprint §5.10).
//  Structure only — no unverified horticultural copy in v1.
//

import Foundation

enum YamadoriQuickGuideKind: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case pine
    case larch
    case spruce

    var id: Self { self }

    var title: String {
        switch self {
        case .pine: "Pine"
        case .larch: "Larch"
        case .spruce: "Spruce"
        }
    }
}

/// Empty shell for future Quick Guide content. Sections exist so UI and Reference
/// Data can wire without inventing care advice.
struct YamadoriQuickGuide: Identifiable, Hashable, Sendable {
    var id: YamadoriQuickGuideKind { kind }
    var kind: YamadoriQuickGuideKind
    /// Reserved — intentionally empty in foundation.
    var sections: [YamadoriQuickGuideSection]

    static let stubs: [YamadoriQuickGuide] = YamadoriQuickGuideKind.allCases.map {
        YamadoriQuickGuide(kind: $0, sections: [])
    }
}

struct YamadoriQuickGuideSection: Identifiable, Hashable, Sendable {
    var id: UUID
    var title: String
    var body: String

    init(id: UUID = UUID(), title: String, body: String = "") {
        self.id = id
        self.title = title
        self.body = body
    }
}
