//
//  SeedBatchListView.swift
//  Bonsai World
//
//  Field Seeds — Seed Batch list + New + stage / Soil Mix filters.
//

import SwiftUI

private enum SeedSoilMixFilter: Hashable {
    case all
    case none
    case mix(UUID)
}

private enum SeedStageFilter: Hashable {
    case all
    case activePath
    case completed
    case failed
    case archived

    var title: String {
        switch self {
        case .all: "All"
        case .activePath: "Active"
        case .completed: "Completed"
        case .failed: "Failed"
        case .archived: "Archived"
        }
    }

    func matches(_ stage: SeedBatchStage) -> Bool {
        switch self {
        case .all: true
        case .activePath: stage.isActive
        case .completed: stage == .completed
        case .failed: stage == .failed
        case .archived: stage == .archived
        }
    }
}

struct SeedBatchListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedBatch: ((UUID) -> Void)? = nil

    @State private var stageFilter: SeedStageFilter = .all
    @State private var soilMixFilter: SeedSoilMixFilter = .all
    @State private var isShowingNew = false
    @State private var pendingCreatedID: UUID?
    @State private var batchPendingDelete: UUID?
    @State private var confirmDelete = false
    @State private var batchPendingAdvance: UUID?
    @State private var confirmAdvance = false

    private var displayedBatches: [SeedBatch] {
        var batches = library.orderedSeedBatches.filter { stageFilter.matches($0.stage) }
        switch soilMixFilter {
        case .all:
            break
        case .none:
            batches = batches.filter { $0.soilMixID == nil }
        case .mix(let id):
            batches = batches.filter { $0.soilMixID == id }
        }
        return batches
    }

    var body: some View {
        Group {
            if library.orderedSeedBatches.isEmpty {
                ContentUnavailableView {
                    Label("Empty", systemImage: "leaf.arrow.circlepath")
                } description: {
                    Text("Add a seed batch to track stratification.")
                } actions: {
                    Button("New Seed Batch") {
                        isShowingNew = true
                    }
                    .accessibilityLabel("New Seed Batch")
                }
            } else {
                batchList
            }
        }
        .navigationTitle("Seeds")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Seed Batch") {
                    isShowingNew = true
                }
                .accessibilityLabel("New Seed Batch")
            }
        }
        .sheet(isPresented: $isShowingNew, onDismiss: {
            if let id = pendingCreatedID {
                pendingCreatedID = nil
                onCreatedBatch?(id)
            }
        }) {
            NewSeedBatchView { id in
                pendingCreatedID = id
            }
        }
        .confirmationDialog(
            "Delete this seed batch?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = batchPendingDelete {
                    library.deleteSeedBatch(id: id)
                }
                batchPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                batchPendingDelete = nil
            }
        } message: {
            Text("Removes the batch and its photos from this device.")
        }
        .confirmationDialog(
            advanceDialogTitle,
            isPresented: $confirmAdvance,
            titleVisibility: .visible
        ) {
            Button("Advance") {
                if let id = batchPendingAdvance {
                    _ = library.advanceSeedBatchStage(id: id)
                }
                batchPendingAdvance = nil
            }
            Button("Cancel", role: .cancel) {
                batchPendingAdvance = nil
            }
        } message: {
            Text("Moves this batch to the next stage.")
        }
    }

    private var advanceDialogTitle: String {
        guard let id = batchPendingAdvance,
              let batch = library.seedBatch(id: id),
              let next = batch.stage.nextActiveStage
        else {
            return "Advance stage?"
        }
        return "Advance to \(next.title)?"
    }

    private var batchList: some View {
        List {
            Section {
                Picker("Stage", selection: $stageFilter) {
                    Text(SeedStageFilter.all.title).tag(SeedStageFilter.all)
                    Text(SeedStageFilter.activePath.title).tag(SeedStageFilter.activePath)
                    Text(SeedStageFilter.completed.title).tag(SeedStageFilter.completed)
                    Text(SeedStageFilter.failed.title).tag(SeedStageFilter.failed)
                    Text(SeedStageFilter.archived.title).tag(SeedStageFilter.archived)
                }
                .accessibilityLabel("Stage filter")

                Picker("Soil Mix", selection: $soilMixFilter) {
                    Text("All").tag(SeedSoilMixFilter.all)
                    Text("None").tag(SeedSoilMixFilter.none)
                    ForEach(library.orderedSoilMixes) { mix in
                        Text(mix.name).tag(SeedSoilMixFilter.mix(mix.id))
                    }
                }
                .accessibilityLabel("Soil Mix filter")
            } header: {
                Text("Filter")
            }

            Section {
                if displayedBatches.isEmpty {
                    Text(emptyFilterMessage)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                } else {
                    ForEach(displayedBatches) { batch in
                        NavigationLink(value: MobileRoute.seedBatch(batch.id)) {
                            batchRow(batch)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if batch.stage.nextActiveStage != nil {
                                Button("Advance") {
                                    batchPendingAdvance = batch.id
                                    confirmAdvance = true
                                }
                                .tint(BonsaiWorldColors.accent)
                                .accessibilityLabel("Advance Stage")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Delete", role: .destructive) {
                                batchPendingDelete = batch.id
                                confirmDelete = true
                            }
                            .accessibilityLabel("Delete Seed Batch")
                        }
                    }
                }
            } footer: {
                if displayedBatches.contains(where: { $0.stage.nextActiveStage != nil }) {
                    Text("Swipe right to Advance stage.")
                        .font(FaloTypography.caption)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private var emptyFilterMessage: String {
        if stageFilter != .all || soilMixFilter != .all {
            return "No batches match these filters."
        }
        return "Empty"
    }

    private func batchRow(_ batch: SeedBatch) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            if let imageID = batch.primaryImageID ?? batch.imageIDs.first {
                MobileAssetImage(imageID: imageID)
            }
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(batch.botanicalName.isEmpty ? batch.batchCode : batch.botanicalName)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text("\(batch.batchCode) · \(batch.stage.title)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                if let mixName = soilMixName(for: batch) {
                    Text(mixName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func soilMixName(for batch: SeedBatch) -> String? {
        guard let mixID = batch.soilMixID,
              let name = library.soilMix(id: mixID)?.name.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty
        else { return nil }
        return name
    }
}

#Preview {
    NavigationStack {
        SeedBatchListView()
    }
    .environment(DemoLibrary.preview)
}
