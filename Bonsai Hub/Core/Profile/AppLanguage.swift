//
//  AppLanguage.swift
//  Bonsai World
//
//  User Profile language preference (display / future localization).
//

import Foundation

enum AppLanguage: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case english
    case norwegian
    case german
    case french
    case spanish

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .english: "English"
        case .norwegian: "Norwegian"
        case .german: "German"
        case .french: "French"
        case .spanish: "Spanish"
        }
    }
}
