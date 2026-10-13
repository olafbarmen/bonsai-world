//
//  MobilePhotoImport.swift
//  Bonsai World
//
//  iOS adapter: camera / photo library → JPEG bytes + pixel size.
//  UIImage stays here. ImageAsset / Tree IDs stay in DemoLibrary.
//

import PhotosUI
import SwiftUI
import UIKit
import UniformTypeIdentifiers

enum MobilePhotoImport {
    static func jpeg(from image: UIImage, fileName: String) -> (data: Data, width: Int, height: Int, fileName: String)? {
        let normalized = image.normalizedUpOrientation
        guard let data = normalized.jpegData(compressionQuality: 0.85), !data.isEmpty else { return nil }
        let width: Int
        let height: Int
        if let cgImage = normalized.cgImage {
            width = cgImage.width
            height = cgImage.height
        } else {
            width = Int((normalized.size.width * normalized.scale).rounded())
            height = Int((normalized.size.height * normalized.scale).rounded())
        }
        return (data, width, height, fileName)
    }

    static func jpeg(from item: PhotosPickerItem) async -> (data: Data, width: Int, height: Int, fileName: String)? {
        if let picked = try? await item.loadTransferable(type: MobilePickedImageData.self),
           let image = UIImage(data: picked.data)
        {
            return jpeg(from: image, fileName: "photo.jpg")
        }
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data)
        else { return nil }
        return jpeg(from: image, fileName: "photo.jpg")
    }

    static var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}

private struct MobilePickedImageData: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .jpeg) { data in
            MobilePickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .heic) { data in
            MobilePickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .png) { data in
            MobilePickedImageData(data: data)
        }
        DataRepresentation(importedContentType: .image) { data in
            MobilePickedImageData(data: data)
        }
    }
}

private extension UIImage {
    var normalizedUpOrientation: UIImage {
        if imageOrientation == .up { return self }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

struct MobileCameraPicker: UIViewControllerRepresentable {
    var onImage: (UIImage) -> Void
    var onCancel: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            DispatchQueue.main.async { context.coordinator.onCancel() }
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImage: onImage, onCancel: onCancel)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImage: (UIImage) -> Void
        let onCancel: () -> Void

        init(onImage: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onImage = onImage
            self.onCancel = onCancel
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImage(image)
            } else {
                onCancel()
            }
        }
    }
}
