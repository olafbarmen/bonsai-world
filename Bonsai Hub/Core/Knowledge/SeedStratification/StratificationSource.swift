//
//  StratificationSource.swift
//  Bonsai World
//
//  Traceability for stratification recommendations.
//

import Foundation

struct StratificationSource: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var title: String
    var organization: String
    var author: String
    var year: Int?
    var sourceType: StratificationSourceType
    var urlString: String?
    var referenceNote: String

    init(
        id: UUID = UUID(),
        title: String,
        organization: String = "",
        author: String = "",
        year: Int? = nil,
        sourceType: StratificationSourceType,
        urlString: String? = nil,
        referenceNote: String = ""
    ) {
        self.id = id
        self.title = title
        self.organization = organization
        self.author = author
        self.year = year
        self.sourceType = sourceType
        self.urlString = urlString
        self.referenceNote = referenceNote
    }

    var displayLine: String {
        var parts: [String] = [title]
        if !organization.isEmpty { parts.append(organization) }
        if let year { parts.append(String(year)) }
        return parts.joined(separator: " · ")
    }
}
