//
//  KnowledgeResource.swift
//  Bonsai World
//
//  Knowledge → Quick Guides / FAQ / Courses / Video Tutorials / External Links (v1).
//

import Foundation

enum KnowledgeResourceKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case quickGuide
    case faq
    case course
    case videoTutorial
    case externalLink

    var id: Self { self }

    var title: String {
        switch self {
        case .quickGuide: "Quick Guides"
        case .faq: "FAQ"
        case .course: "Courses"
        case .videoTutorial: "Video Tutorials"
        case .externalLink: "External Links"
        }
    }

    var singularTitle: String {
        switch self {
        case .quickGuide: "Quick Guide"
        case .faq: "FAQ Entry"
        case .course: "Course"
        case .videoTutorial: "Video Tutorial"
        case .externalLink: "External Link"
        }
    }

    var systemImage: String {
        switch self {
        case .quickGuide: "list.bullet.rectangle"
        case .faq: "questionmark.circle"
        case .course: "rectangle.stack"
        case .videoTutorial: "play.rectangle"
        case .externalLink: "link"
        }
    }

    var route: AppRoute {
        switch self {
        case .quickGuide: .knowledgeQuickGuides
        case .faq: .knowledgeFAQ
        case .course: .knowledgeCourses
        case .videoTutorial: .knowledgeVideos
        case .externalLink: .knowledgeExternalLinks
        }
    }
}

struct KnowledgeResource: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var kind: KnowledgeResourceKind
    var title: String
    var summary: String
    var body: String
    var urlString: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        kind: KnowledgeResourceKind,
        title: String,
        summary: String = "",
        body: String = "",
        urlString: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.summary = summary
        self.body = body
        self.urlString = urlString
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct KnowledgeResourceCreateDraft: Hashable, Sendable {
    var kind: KnowledgeResourceKind
    var title: String
    var summary: String
    var body: String
    var urlString: String
}
