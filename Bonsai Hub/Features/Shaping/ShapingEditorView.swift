//
//  ShapingEditorView.swift
//  Bonsai World
//
//  Tree Detail → Shaping — Vision, then practical development areas.
//

import SwiftUI

struct ShapingEditorView: View {
    let treeID: UUID

    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var shaping = TreeShaping.empty
    @State private var saveTask: Task<Void, Never>?

    private var tree: Tree? {
        treeService.getTree(id: treeID)
    }

    var body: some View {
        FaloAdaptiveDesktopWorkspace(profile: .treeDetail) {
            VStack(alignment: .leading, spacing: ShapingLayout.chapterGap) {
                styleChapter
                visionSection
                shapingSection
            }
        }
        .onAppear {
            loadShaping()
        }
        .onChange(of: treeID) { _, _ in
            loadShaping()
        }
        .onChange(of: shaping) { _, _ in
            scheduleSave()
        }
        .onDisappear {
            saveTask?.cancel()
            persist()
        }
    }

    private var styleChapter: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
            Text("Current Style")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            Text(styleDisplayName)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(tree?.styleID == nil ? .secondary : .primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current Style, \(styleDisplayName)")
    }

    private var visionSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Vision")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            VisionEditorView(treeID: treeID)
        }
    }

    private var shapingSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Shaping")
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            ShapingAreasView(treeID: treeID, shaping: $shaping, onReload: loadShaping)
        }
    }

    private var styleDisplayName: String {
        guard let styleID = tree?.styleID,
              let style = referenceData.style(id: styleID) else {
            return FaloDisplayValue.empty
        }
        return style.name
    }

    private func loadShaping() {
        _ = try? treeService.ensureShapingMigrated(treeID: treeID)
        shaping = treeService.shaping(for: treeID)
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
        try? treeService.updateShaping(treeID: treeID, shaping: shaping)
    }
}
