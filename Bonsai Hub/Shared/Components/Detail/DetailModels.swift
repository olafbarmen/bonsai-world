//
//  DetailModels.swift
//  Bonsai World
//
//  Domain-agnostic models for Falo Detail pages.
//  Tree, Collection, Project, Journal, Gallery, and Locations all map into these.
//

import Foundation

/// A labeled value row for Summary or Information sections.
struct DetailField: Identifiable, Hashable, Sendable {
    let id: String
    let label: String
    let value: String

    init(id: String = UUID().uuidString, label: String, value: String) {
        self.id = id
        self.label = label
        self.value = FaloDisplayValue.text(value)
    }

    init(label: String, value: String) {
        self.init(id: label, label: label, value: value)
    }
}

/// A compact statistic for Detail pages (kept for future Statistics sections).
struct DetailStatistic: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let value: String
    var systemImage: String?

    init(id: String = UUID().uuidString, title: String, value: String, systemImage: String? = nil) {
        self.id = id
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }

    init(title: String, value: String, systemImage: String? = nil) {
        self.init(id: title, title: title, value: value, systemImage: systemImage)
    }
}
