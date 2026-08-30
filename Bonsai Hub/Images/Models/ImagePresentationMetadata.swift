//
//  ImagePresentationMetadata.swift
//  Bonsai World
//
//  Non-destructive presentation recipe for an Original image.
//  Never modifies Original bytes — crop is always reversible (Blueprint §5.5).
//

import CoreGraphics
import Foundation

/// Unit-space crop rectangle (0…1) relative to the Original image.
struct NormalizedCropRect: Codable, Hashable, Sendable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double

    init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    init(_ rect: CGRect) {
        x = Double(rect.origin.x)
        y = Double(rect.origin.y)
        width = Double(rect.size.width)
        height = Double(rect.size.height)
    }

    var cgRect: CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }

    /// Full-frame crop — presentation matches the Original dimensions.
    static let fullFrame = NormalizedCropRect(x: 0, y: 0, width: 1, height: 1)
}

/// Edit recipe stored alongside the immutable Original.
struct ImagePresentationMetadata: Codable, Hashable, Sendable, Identifiable {
    var id: String { "\(sourceImageID.uuidString):\(contextID ?? "")" }

    var sourceImageID: UUID
    var cropNormalizedRect: NormalizedCropRect
    var aspectRatioMode: CropAspectRatioMode
    /// Canvas zoom multiplier when the crop was saved (reserved for re-edit fidelity).
    var zoomLevel: Double
    /// Display surface this recipe belongs to. Omitted on legacy single-crop records.
    var contextID: String?
    var modifiedDate: Date
    var recipeVersion: Int

    init(
        sourceImageID: UUID,
        cropNormalizedRect: NormalizedCropRect = .fullFrame,
        aspectRatioMode: CropAspectRatioMode = .original,
        zoomLevel: Double = 1.0,
        contextID: String? = nil,
        modifiedDate: Date = .now,
        recipeVersion: Int = 1
    ) {
        self.sourceImageID = sourceImageID
        self.cropNormalizedRect = cropNormalizedRect
        self.aspectRatioMode = aspectRatioMode
        self.zoomLevel = zoomLevel
        self.contextID = contextID
        self.modifiedDate = modifiedDate
        self.recipeVersion = recipeVersion
    }

    static func defaultFullFrame(for imageID: UUID) -> ImagePresentationMetadata {
        ImagePresentationMetadata(sourceImageID: imageID)
    }
}
