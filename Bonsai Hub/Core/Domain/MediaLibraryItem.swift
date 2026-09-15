//
//  MediaLibraryItem.swift
//  Bonsai World
//
//  Media → Documents / Videos / Notes / Audio — catalog records (v1).
//

import Foundation

enum MediaLibraryKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case document
    case video
    case note
    case audio

    var id: Self { self }

    var title: String {
        switch self {
        case .document: "Documents"
        case .video: "Videos"
        case .note: "Notes"
        case .audio: "Audio"
        }
    }

    var singularTitle: String {
        switch self {
        case .document: "Document"
        case .video: "Video"
        case .note: "Note"
        case .audio: "Audio"
        }
    }

    var systemImage: String {
        switch self {
        case .document: "doc"
        case .video: "video"
        case .note: "note.text"
        case .audio: "waveform"
        }
    }

    var route: AppRoute {
        switch self {
        case .document: .mediaDocuments
        case .video: .mediaVideo
        case .note: .mediaNotes
        case .audio: .mediaAudio
        }
    }

    var fileTypesHelp: String {
        switch self {
        case .document: "PDF, text, and other document files"
        case .video: "Movie files stored in the library"
        case .note: "Plain-text notes"
        case .audio: "Audio recordings and sound files"
        }
    }
}

struct MediaLibraryItem: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var kind: MediaLibraryKind
    var title: String
    var notes: String
    /// Relative path under the library package (Documents/…), when imported.
    var relativePath: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        kind: MediaLibraryKind,
        title: String,
        notes: String = "",
        relativePath: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.notes = notes
        self.relativePath = relativePath
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct MediaLibraryCreateDraft: Hashable, Sendable {
    var kind: MediaLibraryKind
    var title: String
    var notes: String
    var relativePath: String?
}
