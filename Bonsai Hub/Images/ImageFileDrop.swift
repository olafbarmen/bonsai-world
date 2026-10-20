//
//  ImageFileDrop.swift
//  Bonsai World
//
//  Drag-and-drop of images from Finder and Photos into gallery surfaces.
//  Photos is accepted as a drop, but the files are read on the next turn
//  through item providers. Reading file promises inside the drop reenters
//  the drag session and leaves the tree stuck.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// One dropped image — file path (Finder) or in-memory bytes (Photos).
enum ImageDropSource: Sendable {
    case fileURL(URL)
    case imageData(Data, fileExtension: String, fileName: String)
}

enum ImageFileDrop {
    /// Includes file-promise UTIs so Photos highlighting and drops are accepted.
    static let dropTypes: [UTType] = {
        var types: [UTType] = [
            .fileURL,
            .url,
            .image,
            .jpeg,
            .png,
            .tiff,
            .heic,
            .webP
        ]
        for raw in NSFilePromiseReceiver.readableDraggedTypes {
            if let type = UTType(raw) {
                types.append(type)
            }
        }
        for id in [
            "com.apple.photos.object",
            "com.apple.private.photos.asset",
            "com.apple.live-photo",
            "public.heif"
        ] {
            if let type = UTType(id) {
                types.append(type)
            }
        }
        return types
    }()

    /// Types asked for while the drag is still ending. Promise UTIs stay on ``dropTypes``
    /// so the drop is accepted, but they are not read here — that read reenters the drag.
    fileprivate static let providerTypes: [UTType] = [
        .fileURL,
        .url,
        .image,
        .jpeg,
        .png,
        .tiff,
        .heic,
        .webP
    ]
    private static let supportedExtensions: Set<String> = [
        "heic", "heif", "jpg", "jpeg", "png", "tif", "tiff", "webp"
    ]

    /// HEIC / JPEG / PNG / TIFF paths only (same set as ``ImageImportService``).
    static func acceptedImageURLs(from urls: [URL]) -> [URL] {
        urls.filter { url in
            supportedExtensions.contains(url.pathExtension.lowercased())
        }
    }

    /// Finder file URLs and Photos image data.
    /// Called on the next turn after `performDrop` returns, so a Photos promise
    /// cannot reenter the drag session and freeze the tree.
    @MainActor
    static func handleDrop(
        providers: [NSItemProvider],
        perform: @escaping ([ImageDropSource]) -> Void
    ) {
        Task { @MainActor in
            let sources = await loadSources(from: providers)
            guard !sources.isEmpty else { return }
            perform(sources)
        }
    }

    /// Loads Finder file URLs and Photos image representations from item providers.
    @MainActor
    static func loadSources(from providers: [NSItemProvider]) async -> [ImageDropSource] {
        var results: [ImageDropSource] = []
        results.reserveCapacity(providers.count)

        for provider in providers {
            if let source = await loadSource(from: provider) {
                results.append(source)
            }
        }
        return results
    }

    private static func sourceFromDeliveredFile(_ url: URL) -> ImageDropSource? {
        guard let data = try? Data(contentsOf: url), !data.isEmpty else { return nil }
        let ext = url.pathExtension.lowercased()
        let resolvedExt = supportedExtensions.contains(ext)
            ? ext
            : inferredExtension(for: data, fallback: "jpg")
        guard supportedExtensions.contains(resolvedExt) else { return nil }
        return .imageData(data, fileExtension: resolvedExt, fileName: url.lastPathComponent)
    }

    // MARK: - Item providers

    @MainActor
    private static func loadSource(from provider: NSItemProvider) async -> ImageDropSource? {
        // One image representation. Walking every conforming type waits out a timeout each time.
        let imageTypeIDs = [
            UTType.jpeg.identifier,
            UTType.heic.identifier,
            UTType.png.identifier,
            UTType.tiff.identifier,
            UTType.image.identifier,
            UTType.webP.identifier,
            "public.heif"
        ]
        if let typeID = imageTypeIDs.first(where: { provider.hasItemConformingToTypeIdentifier($0) }),
           let source = await loadFileRepresentation(from: provider, typeIdentifier: typeID) {
            return source
        }

        if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier),
           let url = await loadFileURL(from: provider),
           supportedExtensions.contains(url.pathExtension.lowercased()) {
            return .fileURL(url)
        }

        return nil
    }

    private static func inferredExtension(for data: Data, fallback: String) -> String {
        if data.starts(with: [0xFF, 0xD8, 0xFF]) { return "jpg" }
        if data.starts(with: [0x89, 0x50, 0x4E, 0x47]) { return "png" }
        if data.count >= 4 {
            let be = data.prefix(4)
            if be.elementsEqual([0x49, 0x49, 0x2A, 0x00]) || be.elementsEqual([0x4D, 0x4D, 0x00, 0x2A]) {
                return "tiff"
            }
        }
        if data.count >= 12 {
            let ftyp = data.subdata(in: 4..<8)
            if String(data: ftyp, encoding: .ascii) == "ftyp" { return "heic" }
        }
        if data.starts(with: [0x52, 0x49, 0x46, 0x46]), data.count >= 12 {
            let webp = data.subdata(in: 8..<12)
            if String(data: webp, encoding: .ascii) == "WEBP" { return "webp" }
        }
        return fallback
    }

    /// A provider that never calls back must not keep the drop waiting.
    private static let providerLoadTimeout: TimeInterval = 8

    @MainActor
    private static func loadFileRepresentation(
        from provider: NSItemProvider,
        typeIdentifier: String
    ) async -> ImageDropSource? {
        await withProviderLoad { resume in
            provider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, _ in
                // Temp file is deleted when this callback returns — copy bytes now.
                resume(url.flatMap { sourceFromDeliveredFile($0) })
            }
        }
    }

    @MainActor
    private static func loadFileURL(from provider: NSItemProvider) async -> URL? {
        await withProviderLoad { resume in
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                if let url = item as? URL {
                    resume(url)
                } else if let data = item as? Data,
                          let url = URL(dataRepresentation: data, relativeTo: nil) {
                    resume(url)
                } else if let string = item as? String {
                    resume(URL(fileURLWithPath: string))
                } else {
                    resume(nil)
                }
            }
        }
    }

    @MainActor
    private static func withProviderLoad<T: Sendable>(
        _ start: (@escaping (T?) -> Void) -> Void
    ) async -> T? {
        await withCheckedContinuation { continuation in
            let shot = OneShot<T?> { continuation.resume(returning: $0) }
            let timeout = DispatchWorkItem { shot.resume(nil) }
            DispatchQueue.global(qos: .userInitiated).asyncAfter(
                deadline: .now() + providerLoadTimeout,
                execute: timeout
            )
            start { value in
                timeout.cancel()
                shot.resume(value)
            }
        }
    }
}

// MARK: - DropDelegate

private struct ImageFileDropDelegate: DropDelegate {
    var isTargeted: Binding<Bool>?
    let perform: ([ImageDropSource]) -> Void

    func validateDrop(info: DropInfo) -> Bool {
        true
    }

    func dropEntered(info: DropInfo) {
        isTargeted?.wrappedValue = true
    }

    func dropExited(info: DropInfo) {
        isTargeted?.wrappedValue = false
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .copy)
    }

    func performDrop(info: DropInfo) -> Bool {
        isTargeted?.wrappedValue = false
        let providers = info.itemProviders(for: ImageFileDrop.providerTypes)
        guard !providers.isEmpty else { return false }
        let perform = perform
        // Next turn: performDrop must return before any file is read.
        // Reading a Photos promise inside this call reenters the drag and sticks the tree.
        DispatchQueue.main.async {
            ImageFileDrop.handleDrop(providers: providers, perform: perform)
        }
        return true
    }
}

/// Resumes a provider load once. The timeout and the provider callback can both fire.
private final class OneShot<T>: @unchecked Sendable {
    private let lock = NSLock()
    private var didResume = false
    private var handler: ((T) -> Void)?

    init(_ handler: @escaping (T) -> Void) {
        self.handler = handler
    }

    func resume(_ value: T) {
        lock.lock()
        let deliver = didResume ? nil : handler
        didResume = true
        handler = nil
        lock.unlock()
        deliver?(value)
    }
}

extension View {
    /// Accepts image drops from Finder (file URLs) and Photos (file promises / image data).
    @ViewBuilder
    func bonsaiImageFileDrop(
        isEnabled: Bool,
        isTargeted: Binding<Bool>? = nil,
        perform: @escaping ([ImageDropSource]) -> Void
    ) -> some View {
        if isEnabled {
            self.onDrop(
                of: ImageFileDrop.dropTypes,
                delegate: ImageFileDropDelegate(isTargeted: isTargeted, perform: perform)
            )
        } else {
            self
        }
    }
}
