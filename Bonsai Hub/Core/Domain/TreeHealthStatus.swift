//
//  TreeHealthStatus.swift
//  Bonsai World
//
//  Preview-friendly health labels for Tree Browser rows.
//

import Foundation

enum TreeHealthStatus: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case thriving
    case stable
    case needsAttention
    case recovering

    var id: Self { self }

    var title: String {
        switch self {
        case .thriving: "Thriving"
        case .stable: "Stable"
        case .needsAttention: "Needs Attention"
        case .recovering: "Recovering"
        }
    }

    var systemImage: String {
        switch self {
        case .thriving: "leaf.fill"
        case .stable: "checkmark.circle"
        case .needsAttention: "exclamationmark.triangle"
        case .recovering: "arrow.triangle.2.circlepath"
        }
    }
}
