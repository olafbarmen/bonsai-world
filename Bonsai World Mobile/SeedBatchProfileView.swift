//
//  SeedBatchProfileView.swift
//  Bonsai World
//
//  Seed Batch profile — name, species, stage, photos, notes.
//

import PhotosUI
import SwiftUI
import UIKit

struct SeedBatchProfileView: View {
    @Environment(DemoLibrary.self) private var library

    let batchID: UUID

    @State private var name: String = ""
    @State private var species: String = ""
    @State private var stage: SeedBatchStage = .planned
    @State private var notes: String = ""
    @State private var soilMixID: UUID?
    @State private var didLoad = false
    @State private var confirmAdvance = false
    @State private var isShowingAddPhotoOptions = false
    @State private var isPhotoPickerPresented = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var isShowingCamera = false
    @State private var photoPendingRemoval: UUID?
    @State private var confirmRemovePhoto = false

    private var batch: SeedBatch? { library.seedBatch(id: batchID) }

    private var editableStages: [SeedBatchStage] {
        SeedBatchStage.allCases.filter(\.isActive)
    }

    private var nextStage: SeedBatchStage? {
        batch?.stage.nextActiveStage
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Group {
            if let batch {
                form(batch)
            } else {
                ContentUnavailableView("Seed Batch not found", systemImage: "leaf.arrow.circlepath")
            }
        }
        .onAppear { loadIfNeeded() }
    }

    private func form(_ batch: SeedBatch) -> some View {
        Form {
            if let heroID = batch.primaryImageID ?? batch.imageIDs.first {
                Section {
                    MobileAssetImage(imageID: heroID, style: .hero)
                        .listRowInsets(EdgeInsets(
                            top: FaloSpacing.medium,
                            leading: FaloSpacing.large,
                            bottom: FaloSpacing.medium,
                            trailing: FaloSpacing.large
                        ))
                        .listRowBackground(BonsaiWorldColors.surface)
                        .accessibilityLabel("Primary photo")
                }
            }

            Section {
                if !batch.batchCode.isEmpty {
                    LabeledContent("Code", value: batch.batchCode)
                        .font(FaloTypography.body)
                }
                TextField("Name", text: $name)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Name")
                TextField("Species", text: $species)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Species")
                Picker("Stage", selection: $stage) {
                    ForEach(editableStages) { value in
                        Text(value.title).tag(value)
                    }
                }
            }

            if !library.orderedSoilMixes.isEmpty {
                Section("Soil Mix") {
                    Picker("Soil Mix", selection: $soilMixID) {
                        Text("None").tag(Optional<UUID>.none)
                        ForEach(library.orderedSoilMixes) { mix in
                            Text(mix.name).tag(Optional(mix.id))
                        }
                    }
                    .accessibilityLabel("Soil Mix")

                    if let mixID = soilMixID,
                       let mixName = library.soilMix(id: mixID)?.name.trimmingCharacters(in: .whitespacesAndNewlines),
                       !mixName.isEmpty
                    {
                        NavigationLink(value: MobileRoute.soilMix(mixID)) {
                            Text(mixName)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                        .accessibilityLabel("Open \(mixName)")
                        .accessibilityHint("Open soil mix")
                    }
                }
            }

            if let nextStage {
                Section {
                    Button("Advance Stage") {
                        confirmAdvance = true
                    }
                    .font(FaloTypography.body.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .accessibilityLabel("Advance Stage")
                    .accessibilityHint("Move to \(nextStage.title)")
                } footer: {
                    Text("Next: \(nextStage.title)")
                }
            }

            photosSection(batch)

            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 88)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Notes")
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(seedNavigationTitle(batch))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .confirmationDialog(
            "Advance to \(nextStage?.title ?? "next stage")?",
            isPresented: $confirmAdvance,
            titleVisibility: .visible
        ) {
            Button("Advance") {
                if let advanced = library.advanceSeedBatchStage(id: batchID) {
                    stage = advanced
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog(
            "Remove this photo?",
            isPresented: $confirmRemovePhoto,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                if let imageID = photoPendingRemoval {
                    library.removePhoto(fromSeedBatch: batchID, imageID: imageID)
                }
                photoPendingRemoval = nil
            }
            Button("Cancel", role: .cancel) {
                photoPendingRemoval = nil
            }
        }
        .confirmationDialog("Add Photo", isPresented: $isShowingAddPhotoOptions, titleVisibility: .visible) {
            if MobilePhotoImport.isCameraAvailable {
                Button("Take Photo") { isShowingCamera = true }
            }
            Button("Choose from Photos") { isPhotoPickerPresented = true }
            Button("Cancel", role: .cancel) {}
        }
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
            guard let newItem else { return }
            Task { await importPickedItem(newItem) }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            MobileCameraPicker(
                onImage: { image in
                    isShowingCamera = false
                    importCameraImage(image)
                },
                onCancel: { isShowingCamera = false }
            )
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func photosSection(_ batch: SeedBatch) -> some View {
        Section("Photos") {
            if batch.imageIDs.isEmpty {
                Text("No photos yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(batch.imageIDs, id: \.self) { imageID in
                            Button {
                                library.setPrimaryImage(seedBatchID: batch.id, imageID: imageID)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    MobileAssetImage(imageID: imageID)
                                    if batch.primaryImageID == imageID {
                                        Text("Primary")
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                                            .padding(.horizontal, FaloSpacing.xSmall)
                                            .padding(.vertical, 2)
                                            .background(BonsaiWorldColors.surface.opacity(0.92))
                                            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
                                            .padding(FaloSpacing.xSmall)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Set as Primary") {
                                    library.setPrimaryImage(seedBatchID: batch.id, imageID: imageID)
                                }
                                Button("Remove Photo", role: .destructive) {
                                    photoPendingRemoval = imageID
                                    confirmRemovePhoto = true
                                }
                            }
                            .accessibilityLabel(batch.primaryImageID == imageID ? "Primary photo" : "Set as primary photo")
                            .accessibilityHint("Long press for more options")
                        }
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                }
                .listRowBackground(BonsaiWorldColors.surface)
            }

            Button("Add Photo") {
                isShowingAddPhotoOptions = true
            }
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.accent)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
            .listRowBackground(BonsaiWorldColors.surface)
            .accessibilityLabel("Add Photo")
            .accessibilityHint("Take a photo or choose from Photos")

            if !batch.imageIDs.isEmpty {
                Text("Long press a photo to remove it.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                    .listRowBackground(BonsaiWorldColors.surface)
            }
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let batch else { return }
        name = batch.botanicalName
        species = batch.commonName
        stage = batch.stage.isActive ? batch.stage : .planned
        notes = batch.notes
        soilMixID = batch.soilMixID
        didLoad = true
    }

    private func seedNavigationTitle(_ batch: SeedBatch) -> String {
        let code = batch.batchCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let stageTitle = stage.title
        if code.isEmpty { return stageTitle }
        return "\(code) · \(stageTitle)"
    }

    private func save() {
        library.updateSeedBatch(
            id: batchID,
            name: name,
            species: species,
            stage: stage,
            notes: notes,
            soilMixID: soilMixID
        )
    }

    private func importPickedItem(_ item: PhotosPickerItem) async {
        photoPickerItem = nil
        guard let jpeg = await MobilePhotoImport.jpeg(from: item) else { return }
        _ = library.addPhoto(
            toSeedBatch: batchID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }

    private func importCameraImage(_ image: UIImage) {
        guard let jpeg = MobilePhotoImport.jpeg(from: image, fileName: "camera.jpg") else { return }
        _ = library.addPhoto(
            toSeedBatch: batchID,
            jpegData: jpeg.data,
            width: jpeg.width,
            height: jpeg.height,
            fileName: jpeg.fileName
        )
    }
}

#Preview {
    NavigationStack {
        SeedBatchProfileView(batchID: UUID())
    }
    .environment(DemoLibrary.preview)
}
