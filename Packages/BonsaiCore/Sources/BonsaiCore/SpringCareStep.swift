//
//  SpringCareStep.swift
//  BonsaiCore
//
//  Checklist steps for Spring Care (date-triggered return to summer placement).
//

import Foundation

enum SpringCareStep: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case moveToSummerPlacement

    var id: Self { self }

    var title: String {
        switch self {
        case .moveToSummerPlacement: "Move to summer placement"
        }
    }

    var help: String {
        switch self {
        case .moveToSummerPlacement:
            "Move the tree from winter protection to its summer place, then update Location if needed."
        }
    }
}
