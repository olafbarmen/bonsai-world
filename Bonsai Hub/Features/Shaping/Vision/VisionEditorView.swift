//
//  VisionEditorView.swift
//  Bonsai World
//
//  Shaping → Vision — long-term intention and reference images only.
//

import SwiftUI

struct VisionEditorView: View {
    let treeID: UUID

    @Environment(TreeService.self) private var treeService

    @State private var vision = TreeVision.empty
    @State private var saveTask: Task<Void, Never>?

    private var tree: Tree? {
        treeService.getTree(id: treeID)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
            visionStatementBlock
            referenceImagesBlock
        }
        .onAppear {
            vision = sanitizedVision(from: tree)
        }
        .onChange(of: treeID) { _, _ in
            vision = sanitizedVision(from: tree)
        }
        .onChange(of: vision) { _, _ in
            scheduleSave()
        }
        .onDisappear {
            saveTask?.cancel()
            persist()
        }
    }

    private var visionStatementBlock: some View {
        DetailCard(title: "What do I want this tree to become?") {
            TextEditor(text: $vision.statement)
                .font(FaloCardTypography.fieldValue)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 160, alignment: .topLeading)
                .padding(FaloSpacing.small)
                .background {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(Color(nsColor: .textBackgroundColor))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .accessibilityLabel("Vision Statement")
        }
    }

    private var referenceImagesBlock: some View {
        DetailCard(title: "Reference Images") {
            ShapingReferenceImagesSection(
                treeID: treeID,
                imageIDs: $vision.referenceImageIDs,
                showsTitle: false,
                helperText: "Inspiration for this Vision — not photos of this tree."
            )
        }
    }

    private func sanitizedVision(from tree: Tree?) -> TreeVision {
        var vision = tree?.vision ?? .empty
        vision.migrateLegacyCharacteristicsIfNeeded()
        vision.targetStyleID = nil
        return vision
    }

    private func scheduleSave() {
        saveTask?.cancel()
        saveTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            guard !Task.isCancelled else { return }
            persist()
        }
    }

    private func persist() {
        var visionToSave = vision
        visionToSave.prepareForSave()
        try? treeService.updateVision(treeID: treeID, vision: visionToSave)
    }
}
