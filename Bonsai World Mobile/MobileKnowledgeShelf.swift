//
//  MobileKnowledgeShelf.swift
//  Bonsai World
//
//  Empty Knowledge lists that match the Mac titles.
//

import SwiftUI

enum MobileKnowledgeShelf: String, Hashable, CaseIterable {
    case quickGuides
    case videos
    case courses
    case faq
    case externalLinks

    var title: String {
        switch self {
        case .quickGuides: "Quick Guides"
        case .videos: "Video Tutorials"
        case .courses: "Courses"
        case .faq: "FAQ"
        case .externalLinks: "External Links"
        }
    }

    var emptyLine: String {
        "No \(title.lowercased()) yet."
    }
}

struct MobileKnowledgeShelfView: View {
    let shelf: MobileKnowledgeShelf

    var body: some View {
        ContentUnavailableView(
            shelf.emptyLine,
            systemImage: "book.closed"
        )
        .navigationTitle(shelf.title)
    }
}
