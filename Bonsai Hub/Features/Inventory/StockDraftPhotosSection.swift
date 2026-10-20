//
//  StockDraftPhotosSection.swift
//  Bonsai World
//
//  Photos on Add Soil / Add Inventory Stock sheets — same import path as detail,
//  kept on the draft until the line is saved.
//

import SwiftUI

struct StockDraftPhotosSection: View {
    @Binding var primaryImageID: UUID?
    @Binding var imageIDs: [UUID]
    @Binding var selectedImageID: UUID?

    var onAddImage: () -> Void
    var onDropImageFiles: (([ImageDropSource]) -> Void)? = nil

    var body: some View {
        Section("Photos") {
            PotIdentityPhotosSection(
                imageIDs: imageIDs,
                primaryImageID: primaryImageID,
                selectedImageID: $selectedImageID,
                onAddImage: onAddImage,
                onDropImageFiles: onDropImageFiles,
                onSetPrimary: { id in
                    primaryImageID = id
                    if !imageIDs.contains(id) {
                        imageIDs.insert(id, at: 0)
                    }
                },
                onRemove: { id in
                    imageIDs.removeAll { $0 == id }
                    if primaryImageID == id {
                        primaryImageID = imageIDs.first
                    }
                    if selectedImageID == id {
                        selectedImageID = primaryImageID ?? imageIDs.first
                    }
                }
            )
        }
    }
}
