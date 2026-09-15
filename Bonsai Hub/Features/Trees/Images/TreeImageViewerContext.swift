//
//  TreeImageViewerContext.swift
//  Bonsai World
//
//  Session model for the Tree Image Viewer window.
//  Holds gallery identity + selection so future zoom / pan / next-previous /
//  slideshow / compare / before-after / history can attach without redesign.
//

import Foundation

/// Opens the dedicated Tree Image Viewer over Tree Detail.
struct TreeImageViewerContext: Identifiable, Codable, Hashable, Sendable {
    /// Stable window identity for this viewing session.
    var id: UUID
    /// Owning tree — return context after close stays on this tree.
    var treeID: UUID
    /// Ordered gallery (chronological / stored `imageIDs` order).
    var imageIDs: [UUID]
    /// Image shown as the main preview when the viewer opens.
    var selectedImageID: UUID

    // MARK: - Future extension points (not used yet)

    /// Reserved for before/after and side-by-side comparison.
    var comparisonImageID: UUID? = nil
    /// Reserved for viewer presentation modes (single, compare, slideshow, history).
    var presentationMode: TreeImageViewerPresentationMode = .single
    /// Which saved display crop to apply when loading pixels.
    var displayContext: ImagePresentationContext = .treeThumbnail

    init(
        id: UUID = UUID(),
        treeID: UUID,
        imageIDs: [UUID],
        selectedImageID: UUID,
        comparisonImageID: UUID? = nil,
        presentationMode: TreeImageViewerPresentationMode = .single,
        displayContext: ImagePresentationContext = .treeThumbnail
    ) {
        self.id = id
        self.treeID = treeID
        self.imageIDs = imageIDs
        self.selectedImageID = selectedImageID
        self.comparisonImageID = comparisonImageID
        self.presentationMode = presentationMode
        self.displayContext = displayContext
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case treeID
        case imageIDs
        case selectedImageID
        case comparisonImageID
        case presentationMode
        case displayContext
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        treeID = try container.decode(UUID.self, forKey: .treeID)
        imageIDs = try container.decode([UUID].self, forKey: .imageIDs)
        selectedImageID = try container.decode(UUID.self, forKey: .selectedImageID)
        comparisonImageID = try container.decodeIfPresent(UUID.self, forKey: .comparisonImageID)
        presentationMode = try container.decodeIfPresent(TreeImageViewerPresentationMode.self, forKey: .presentationMode) ?? .single
        displayContext = try container.decodeIfPresent(ImagePresentationContext.self, forKey: .displayContext) ?? .treeThumbnail
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(treeID, forKey: .treeID)
        try container.encode(imageIDs, forKey: .imageIDs)
        try container.encode(selectedImageID, forKey: .selectedImageID)
        try container.encodeIfPresent(comparisonImageID, forKey: .comparisonImageID)
        try container.encode(presentationMode, forKey: .presentationMode)
        try container.encode(displayContext, forKey: .displayContext)
    }

    var selectedIndex: Int? {
        imageIDs.firstIndex(of: selectedImageID)
    }
}

/// Viewer modes reserved for future Photo Manager capabilities.
enum TreeImageViewerPresentationMode: String, Codable, Hashable, Sendable {
    case single
    case compare
    case beforeAfter
    case slideshow
    case history
}

/// Documented capabilities — architecture only; no UI wiring yet.
enum TreeImageViewerCapability: String, CaseIterable, Sendable {
    case zoom
    case pan
    case nextPrevious
    case slideshow
    case compare
    case beforeAfter
    case history
}

extension TreeImageViewerContext {
    static let windowID = "tree-image-viewer"
}
