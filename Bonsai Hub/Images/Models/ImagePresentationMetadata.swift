//
//  ImagePresentationMetadata.swift
//  Bonsai World
//
//  Non-destructive presentation recipe for an Original image.
//  Never modifies Original bytes — crop is always reversible (Blueprint §5.5).
//

import CoreGraphics
import Foundation

/// Unit-space crop rectangle (0…1) relative to the rotated presentation.
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

    /// 90° clockwise in unit space (top-left origin, y down).
    func rotatedClockwise90() -> NormalizedCropRect {
        NormalizedCropRect(
            x: 1 - y - height,
            y: x,
            width: height,
            height: width
        )
    }

    /// Horizontal mirror in unit space (top-left origin).
    func mirroredHorizontally() -> NormalizedCropRect {
        NormalizedCropRect(
            x: 1 - x - width,
            y: y,
            width: width,
            height: height
        )
    }
}

/// Edit recipe stored alongside the immutable Original.
struct ImagePresentationMetadata: Codable, Hashable, Sendable, Identifiable {
    var id: String { "\(sourceImageID.uuidString):\(contextID ?? "")" }

    var sourceImageID: UUID
    var cropNormalizedRect: NormalizedCropRect
    var aspectRatioMode: CropAspectRatioMode
    /// Canvas zoom multiplier when the crop was saved (reserved for re-edit fidelity).
    var zoomLevel: Double
    /// Clockwise display rotation in degrees: 0, 90, 180, or 270. Original bytes stay unrotated.
    var rotationDegrees: Int
    /// Horizontal mirror after rotation. Original bytes stay unflipped.
    var isMirroredHorizontally: Bool
    /// Display surface this recipe belongs to. Omitted on legacy single-crop records.
    var contextID: String?
    var modifiedDate: Date
    var recipeVersion: Int

    init(
        sourceImageID: UUID,
        cropNormalizedRect: NormalizedCropRect = .fullFrame,
        aspectRatioMode: CropAspectRatioMode = .original,
        zoomLevel: Double = 1.0,
        rotationDegrees: Int = 0,
        isMirroredHorizontally: Bool = false,
        contextID: String? = nil,
        modifiedDate: Date = .now,
        recipeVersion: Int = 1
    ) {
        self.sourceImageID = sourceImageID
        self.cropNormalizedRect = cropNormalizedRect
        self.aspectRatioMode = aspectRatioMode
        self.zoomLevel = zoomLevel
        self.rotationDegrees = Self.normalizedRotation(rotationDegrees)
        self.isMirroredHorizontally = isMirroredHorizontally
        self.contextID = contextID
        self.modifiedDate = modifiedDate
        self.recipeVersion = recipeVersion
    }

    static func normalizedRotation(_ degrees: Int) -> Int {
        let stepped = ((degrees / 90) % 4 + 4) % 4
        return stepped * 90
    }

    static func defaultFullFrame(for imageID: UUID) -> ImagePresentationMetadata {
        ImagePresentationMetadata(sourceImageID: imageID)
    }

    enum CodingKeys: String, CodingKey {
        case sourceImageID, cropNormalizedRect, aspectRatioMode, zoomLevel
        case rotationDegrees, isMirroredHorizontally, contextID, modifiedDate, recipeVersion
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceImageID = try container.decode(UUID.self, forKey: .sourceImageID)
        cropNormalizedRect = try container.decode(NormalizedCropRect.self, forKey: .cropNormalizedRect)
        aspectRatioMode = try container.decode(CropAspectRatioMode.self, forKey: .aspectRatioMode)
        zoomLevel = try container.decode(Double.self, forKey: .zoomLevel)
        rotationDegrees = Self.normalizedRotation(
            try container.decodeIfPresent(Int.self, forKey: .rotationDegrees) ?? 0
        )
        isMirroredHorizontally = try container.decodeIfPresent(Bool.self, forKey: .isMirroredHorizontally) ?? false
        contextID = try container.decodeIfPresent(String.self, forKey: .contextID)
        modifiedDate = try container.decode(Date.self, forKey: .modifiedDate)
        recipeVersion = try container.decode(Int.self, forKey: .recipeVersion)
    }
}
