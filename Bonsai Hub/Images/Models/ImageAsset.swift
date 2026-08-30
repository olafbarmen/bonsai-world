//
//  ImageAsset.swift
//  Bonsai World
//
//  Metadata for a Tree Photo in the Bonsai World Library.
//  Stores identifiers and relative library paths only — never absolute file paths.
//  Pixel data is resolved via StorageService + ImageService.
//

import Foundation

/// Library photo / image metadata (Tree Photo record).
struct ImageAsset: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    /// Original file name as imported (provenance — not shown in filmstrip).
    var fileName: String
    /// User-facing Photo Name (filmstrip label).
    var photoName: String
    /// Path relative to the library root (e.g. `Images/Originals/<id>.jpg`).
    var relativePath: String
    /// Import Date — when the photo entered the library (system / internal).
    var createdDate: Date
    var modifiedDate: Date
    /// Byte size of the original file when known; `0` until import fills it in.
    var fileSize: Int64
    var width: Int
    var height: Int
    /// Whether this asset is marked primary on its owning tree (denormalized convenience).
    var isPrimary: Bool
    /// Library-wide featured prominence (Gallery browse / Dashboard — future workflow).
    var isFeatured: Bool

    /// Capture Date — when the photo was actually taken (EXIF when available).
    /// Stored as `photoDate` for catalog compatibility.
    var photoDate: Date?

    // MARK: - Future metadata (model ready; UI later)

    var caption: String
    var photographer: String
    var camera: String
    var tags: [String]
    var notes: String

    /// User-facing Capture Date. Always resolved (falls back to Import Date).
    var captureDate: Date {
        get { photoDate ?? createdDate }
        set { photoDate = newValue }
    }

    /// Import Date alias (internal).
    var importDate: Date { createdDate }

    init(
        id: UUID = UUID(),
        fileName: String,
        photoName: String = "",
        relativePath: String,
        createdDate: Date = .now,
        modifiedDate: Date = .now,
        fileSize: Int64 = 0,
        width: Int = 0,
        height: Int = 0,
        isPrimary: Bool = false,
        isFeatured: Bool = false,
        photoDate: Date? = nil,
        caption: String = "",
        photographer: String = "",
        camera: String = "",
        tags: [String] = [],
        notes: String = ""
    ) {
        self.id = id
        self.fileName = fileName
        let resolvedCapture = photoDate ?? createdDate
        self.photoName = photoName.isEmpty
            ? Self.defaultPhotoName(for: resolvedCapture)
            : photoName
        self.relativePath = relativePath
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.fileSize = fileSize
        self.width = width
        self.height = height
        self.isPrimary = isPrimary
        self.isFeatured = isFeatured
        self.photoDate = resolvedCapture
        self.caption = caption
        self.photographer = photographer
        self.camera = camera
        self.tags = tags
        self.notes = notes
    }

    /// Relative path convention for originals inside the library package.
    static func originalsRelativePath(id: UUID, fileExtension: String = "jpg") -> String {
        "Images/Originals/\(id.uuidString).\(fileExtension)"
    }

    /// Default Photo Name when the user leaves the field empty (`yyyy-MM-dd` from Capture Date).
    static func defaultPhotoName(for date: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    /// Filmstrip Capture Date label, e.g. `12 Apr 2025`.
    static func displayCaptureDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case id, fileName, photoName, relativePath, createdDate, modifiedDate
        case fileSize, width, height, isPrimary, isFeatured
        case photoDate, caption, photographer, camera, tags, notes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        fileName = try container.decode(String.self, forKey: .fileName)
        relativePath = try container.decode(String.self, forKey: .relativePath)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        modifiedDate = try container.decode(Date.self, forKey: .modifiedDate)
        fileSize = try container.decode(Int64.self, forKey: .fileSize)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        isPrimary = try container.decode(Bool.self, forKey: .isPrimary)
        isFeatured = try container.decodeIfPresent(Bool.self, forKey: .isFeatured) ?? false
        caption = try container.decodeIfPresent(String.self, forKey: .caption) ?? ""
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        photographer = try container.decodeIfPresent(String.self, forKey: .photographer) ?? ""
        camera = try container.decodeIfPresent(String.self, forKey: .camera) ?? ""
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        let decodedCapture = try container.decodeIfPresent(Date.self, forKey: .photoDate)
        photoDate = decodedCapture ?? createdDate
        let decodedName = try container.decodeIfPresent(String.self, forKey: .photoName) ?? ""
        photoName = decodedName.isEmpty
            ? Self.defaultPhotoName(for: photoDate ?? createdDate)
            : decodedName
    }
}

/// Compatibility alias — Tree Photo is stored as ``ImageAsset``.
typealias TreePhoto = ImageAsset
