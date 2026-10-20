//
//  SeedBatchProfileView.swift
//  Bonsai World
//
//  Seed Batch profile — Mac SeedBatchDetailView fields and work actions the model supports.
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
    @State private var source: String = ""
    @State private var seedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var locationID: UUID?
    @State private var containerDescription: String = ""
    @State private var initialSeedCountText = ""
    @State private var viableSeedCountText = ""
    @State private var sownCountText = ""
    @State private var germCountText = ""
    @State private var survivingCountText = ""
    @State private var selectCountText = ""
    @State private var didLoad = false
    @State private var confirmAdvance = false
    @State private var confirmFailed = false
    @State private var showSow = false
    @State private var showGerm = false
    @State private var showSurvive = false
    @State private var showSeparate = false
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
                formContent(batch)
            } else {
                ContentUnavailableView("Seed Batch not found", systemImage: "leaf.arrow.circlepath")
            }
        }
        .onAppear { loadIfNeeded() }
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
            "Mark this batch failed?",
            isPresented: $confirmFailed,
            titleVisibility: .visible
        ) {
            Button("Mark Failed", role: .destructive) {
                _ = library.markSeedBatchFailed(id: batchID)
                stage = .failed
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
        .sheet(isPresented: $showSow) { sowSheet }
        .sheet(isPresented: $showGerm) { germSheet }
        .sheet(isPresented: $showSurvive) { surviveSheet }
        .sheet(isPresented: $showSeparate) { separateSheet }
    }

    private func formContent(_ batch: SeedBatch) -> some View {
        Form {
            heroSection(batch)
            identitySection
            currentSection(batch)
            resultsSection(batch)
            soilMixSection
            actionsSection(batch)
            timelineSection(batch)
            photosSection(batch)
            notesSection
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
        .toolbarColorScheme(.light, for: .navigationBar)
    }

    @ViewBuilder
    private func heroSection(_ batch: SeedBatch) -> some View {
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
    }

    private var identitySection: some View {
        Section {
            if let code = batch?.batchCode, !code.isEmpty {
                LabeledContent("Code", value: code)
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
            TextField("Source", text: $source)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Source")
            TextField("Seed year", value: $seedYear, format: .number.grouping(.never))
                .keyboardType(.numberPad)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Seed year")
            TextField("Number of seeds", text: $initialSeedCountText)
                .keyboardType(.numberPad)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Number of seeds")
        }
    }

    private func currentSection(_ batch: SeedBatch) -> some View {
        Section("Current") {
            LabeledContent("Stage", value: batch.stage.title)
            Picker("Location", selection: $locationID) {
                Text("None").tag(Optional<UUID>.none)
                ForEach(library.orderedLocations) { location in
                    Text(location.name).tag(Optional(location.id))
                }
            }
            .accessibilityLabel("Location")
            TextField("Container", text: $containerDescription)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Container")
            TextField("Viable", text: $viableSeedCountText)
                .keyboardType(.numberPad)
            TextField("Sown", text: $sownCountText)
                .keyboardType(.numberPad)
            TextField("Germinated", text: $germCountText)
                .keyboardType(.numberPad)
            TextField("Surviving", text: $survivingCountText)
                .keyboardType(.numberPad)
            LabeledContent("Selected", value: "\(batch.selectedTreeCount)")
            LabeledContent("Trees created", value: "\(batch.createdTreeIDs.count)")
        }
    }

    private func resultsSection(_ batch: SeedBatch) -> some View {
        Section("Propagation Results") {
            LabeledContent("Germination", value: SeedBatch.percentLabel(batch.germinationRate))
            LabeledContent("Seedling survival", value: SeedBatch.percentLabel(batch.survivalRate))
            LabeledContent("Seed → seedling", value: SeedBatch.percentLabel(batch.seedToSeedlingRate))
            LabeledContent("Seed → tree", value: SeedBatch.percentLabel(batch.seedToTreeRate))
        }
    }

    @ViewBuilder
    private var soilMixSection: some View {
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
    }

    private func actionsSection(_ batch: SeedBatch) -> some View {
        Section {
            if nextStage != nil {
                Button("Advance Stage") {
                    confirmAdvance = true
                }
                .accessibilityLabel("Advance Stage")
            }
            if batch.stage == .readyToSow || batch.stage == .stratifying || batch.stage == .planned {
                Button("Record Sowing") { showSow = true }
            }
            if batch.stage == .sown || batch.stage == .germinating {
                Button("Record Germination") { showGerm = true }
            }
            if batch.stage == .germinating || batch.stage == .seedling || batch.stage == .developing {
                Button("Update Survival") { showSurvive = true }
                Button("Separate Seedlings") { showSeparate = true }
            }
            if batch.stage.isActive {
                Button("Mark Failed", role: .destructive) {
                    confirmFailed = true
                }
            }
        } header: {
            Text("Actions")
        } footer: {
            if let nextStage {
                Text("Next: \(nextStage.title)")
            }
        }
    }

    @ViewBuilder
    private func timelineSection(_ batch: SeedBatch) -> some View {
        if !batch.orderedEvents.isEmpty {
            Section("Timeline") {
                ForEach(Array(batch.orderedEvents.reversed().prefix(20))) { event in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(event.date.formatted(date: .abbreviated, time: .shortened))
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Text(event.kind.title)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        if let quantity = event.quantity {
                            Text("Quantity: \(quantity)")
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                        if !event.notes.isEmpty {
                            Text(event.notes)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                }
            }
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            TextEditor(text: $notes)
                .frame(minHeight: 88)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .accessibilityLabel("Notes")
        }
    }

    private var sowSheet: some View {
        NavigationStack {
            Form {
                Section("Sowing") {
                    TextField("Seeds sown", text: $sownCountText)
                        .keyboardType(.numberPad)
                    Picker("Soil mix", selection: $soilMixID) {
                        Text("Select").tag(Optional<UUID>.none)
                        ForEach(library.orderedSoilMixes) { mix in
                            Text(mix.name).tag(Optional(mix.id))
                        }
                    }
                    TextField("Container", text: $containerDescription)
                    Picker("Location", selection: $locationID) {
                        Text("Keep current").tag(Optional<UUID>.none)
                        ForEach(library.orderedLocations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                }
            }
            .navigationTitle("Record Sowing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showSow = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(sownCountText), count > 0 else { return }
                        if library.recordSeedBatchSowing(
                            id: batchID,
                            sownCount: count,
                            soilMixID: soilMixID,
                            locationID: locationID,
                            containerDescription: containerDescription
                        ) {
                            stage = library.seedBatch(id: batchID)?.stage ?? stage
                            showSow = false
                        }
                    }
                }
            }
        }
    }

    private var germSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Germinated count", text: $germCountText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Record Germination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showGerm = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(germCountText), count >= 0 else { return }
                        if library.recordSeedBatchGermination(id: batchID, germinatedCount: count) {
                            stage = library.seedBatch(id: batchID)?.stage ?? stage
                            showGerm = false
                        }
                    }
                }
            }
        }
    }

    private var surviveSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Surviving seedlings", text: $survivingCountText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Update Survival")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showSurvive = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(survivingCountText), count >= 0 else { return }
                        if library.updateSeedBatchSurvival(id: batchID, survivingCount: count) {
                            stage = library.seedBatch(id: batchID)?.stage ?? stage
                            showSurvive = false
                        }
                    }
                }
            }
        }
    }

    private var separateSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Seedlings to select", text: $selectCountText)
                        .keyboardType(.numberPad)
                } footer: {
                    if let batch {
                        Text("Surviving: \(batch.survivingSeedlingCount)")
                    }
                }
            }
            .navigationTitle("Separate Seedlings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showSeparate = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(selectCountText), count > 0 else { return }
                        if library.separateSeedBatchSeedlings(id: batchID, selectCount: count) {
                            stage = library.seedBatch(id: batchID)?.stage ?? stage
                            survivingCountText = "\(library.seedBatch(id: batchID)?.survivingSeedlingCount ?? 0)"
                            showSeparate = false
                        }
                    }
                }
            }
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
        source = batch.source
        seedYear = batch.seedYear
        locationID = batch.locationID
        containerDescription = batch.containerDescription
        initialSeedCountText = "\(batch.initialSeedCount)"
        viableSeedCountText = "\(batch.viableSeedCount)"
        sownCountText = "\(batch.sownSeedCount)"
        germCountText = "\(batch.germinatedSeedCount)"
        survivingCountText = "\(batch.survivingSeedlingCount)"
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
            soilMixID: soilMixID,
            source: source,
            seedYear: seedYear,
            containerDescription: containerDescription,
            initialSeedCount: Int(initialSeedCountText),
            viableSeedCount: Int(viableSeedCountText),
            sownSeedCount: Int(sownCountText),
            germinatedSeedCount: Int(germCountText),
            survivingSeedlingCount: Int(survivingCountText)
        )
        library.setSeedBatchLocation(id: batchID, locationID: locationID)
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
