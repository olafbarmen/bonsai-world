//
//  SeedBatchDetailView.swift
//  Bonsai World
//
//  Active batch detail — stage, next action, timeline, metrics, lifecycle actions.
//

import SwiftUI

struct SeedBatchDetailView: View {
    let batchID: UUID

    @Environment(AppState.self) private var appState
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(SeedStratificationCatalogService.self) private var catalog
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService

    @State private var errorMessage: String?
    @State private var checkNotes = ""
    @State private var sownCount = ""
    @State private var germCount = ""
    @State private var survivingCount = ""
    @State private var selectCount = ""
    @State private var createTreeCount = ""
    @State private var stratificationSoilMixID: UUID?
    @State private var stratificationNotes = ""
    @State private var container = ""
    @State private var soilMixID: UUID?
    @State private var actionLocationID: UUID?
    @State private var showStartStrat = false
    @State private var showChangeTime = false
    @State private var changeTimeDays = ""
    @State private var changeTimeNotes = ""
    @State private var showSow = false
    @State private var showGerm = false
    @State private var showSurvive = false
    @State private var showSeparate = false
    @State private var showCreateTrees = false

    private var batch: SeedBatch? {
        seedBatchService.batch(id: batchID)
    }

    private var profile: SpeciesStratificationProfile? {
        guard let batch else { return nil }
        return catalog.profile(speciesID: batch.speciesID)
            ?? catalog.profile(matchingScientificName: batch.botanicalName)
    }

    /// Mixes tagged Seeds — stratification medium and sowing mix picker.
    private var seedSoilMixes: [SoilMix] {
        referenceData.soilMixes
            .filter(\.isActive)
            .filter { $0.contextTags.contains(.seeds) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        Group {
            if let batch {
                content(batch)
            } else {
                ContentUnavailableView("Batch Not Found", systemImage: "leaf")
            }
        }
        .alert("Could Not Update Batch", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func content(_ batch: SeedBatch) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                header(batch)
                lifecycleIndicator(batch)
                nextAction(batch)
                summary(batch)
                metrics(batch)
                scientificVsUser(batch)
                actions(batch)
                timeline(batch)
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .onAppear { consumePendingQuickAction() }
        .onChange(of: appState.pendingSeedBatchQuickAction) { _, _ in
            consumePendingQuickAction()
        }
        .sheet(isPresented: $showStartStrat) { startStratSheet(batch) }
        .sheet(isPresented: $showChangeTime) { changeTimeSheet(batch) }
        .sheet(isPresented: $showSow) { sowSheet(batch) }
        .sheet(isPresented: $showGerm) { germSheet(batch) }
        .sheet(isPresented: $showSurvive) { surviveSheet(batch) }
        .sheet(isPresented: $showSeparate) { separateSheet(batch) }
        .sheet(isPresented: $showCreateTrees) { createTreesSheet(batch) }
    }

    private func consumePendingQuickAction() {
        guard let request = appState.pendingSeedBatchQuickAction else { return }
        appState.clearPendingSeedBatchQuickAction()
        handle(request.command)
    }

    private func handle(_ command: SeedBatchQuickActionCommand) {
        guard let batch else { return }
        switch command {
        case .startStratification:
            showStartStrat = true
        case .skipToReadyToSow:
            run {
                _ = try seedBatchService.startStratification(
                    batchID: batch.id,
                    mediumDescription: "",
                    locationID: batch.locationID
                )
            }
        case .completeCurrentPhase:
            run { _ = try seedBatchService.completeCurrentTreatmentPhase(batchID: batch.id) }
        case .extendPhase:
            run {
                _ = try seedBatchService.extendCurrentPhase(
                    batchID: batch.id,
                    additionalDays: 7,
                    reason: "User extended treatment"
                )
            }
        case .changeTime:
            changeTimeDays = batch.currentPhase?.selectedDurationDays.map(String.init) ?? ""
            changeTimeNotes = ""
            showChangeTime = true
        case .recordSowing:
            showSow = true
        case .recordGermination:
            showGerm = true
        case .updateSurvival:
            showSurvive = true
        case .separateSeedlings:
            showSeparate = true
        case .createTrees:
            showCreateTrees = true
        case .markFailed:
            run { _ = try seedBatchService.markFailed(batchID: batch.id, notes: "Marked failed by grower") }
        }
    }

    private func header(_ batch: SeedBatch) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(batch.botanicalName)
                .font(FaloTypography.headline)
            Text(batch.commonName.isEmpty ? batch.batchCode : "\(batch.commonName) · \(batch.batchCode)")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
            Text("\(batch.initialSeedCount) seeds")
                .font(FaloCardTypography.fieldValue)
        }
    }

    private func lifecycleIndicator(_ batch: SeedBatch) -> some View {
        let stages: [(SeedBatchStage, String)] = [
            (.planned, "Seed"),
            (.stratifying, "Stratification"),
            (.sown, "Sowing"),
            (.germinating, "Germination"),
            (.seedling, "Seedling"),
            (.developing, "Tree")
        ]
        return DetailCard(title: "Lifecycle") {
            HStack(spacing: FaloSpacing.medium) {
                ForEach(stages, id: \.1) { stage, label in
                    VStack(spacing: 4) {
                        Image(systemName: lifecycleSymbol(batch.stage, milestone: stage))
                            .foregroundStyle(.secondary)
                        Text(label)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            DetailLabeledRow(label: "Current stage", value: batch.stage.title)
        }
    }

    private func lifecycleSymbol(_ current: SeedBatchStage, milestone: SeedBatchStage) -> String {
        let order: [SeedBatchStage] = [.planned, .stratifying, .readyToSow, .sown, .germinating, .seedling, .developing, .completed]
        let c = order.firstIndex(of: current) ?? 0
        let m = order.firstIndex(of: milestone) ?? 0
        if current == milestone || (milestone == .stratifying && current == .readyToSow) {
            return "circle.fill"
        }
        return c > m ? "checkmark.circle.fill" : "circle"
    }

    @ViewBuilder
    private func nextAction(_ batch: SeedBatch) -> some View {
        let tasks = seedBatchService.pendingTasks(for: batch.id)
        DetailCard(title: "Next Task") {
            if let task = tasks.first {
                Text(task.title)
                    .font(FaloCardTypography.fieldValue)
                Text("Due \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if batch.stage == .stratifying {
                    TextField("Check notes", text: $checkNotes)
                    Button("Complete Check") {
                        run { _ = try seedBatchService.completeCheck(batchID: batch.id, notes: checkNotes) }
                        checkNotes = ""
                    }
                }
            } else {
                Text(defaultNextPrompt(batch))
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func defaultNextPrompt(_ batch: SeedBatch) -> String {
        switch batch.stage {
        case .planned: return "Start stratification (or mark ready to sow if none required)."
        case .readyToSow: return "Record sowing."
        case .sown, .germinating: return "Record germination counts."
        case .seedling: return "Record survival or separate seedlings."
        case .developing: return "Create trees from selected seedlings."
        default: return "No pending action."
        }
    }

    private func summary(_ batch: SeedBatch) -> some View {
        DetailCard(title: "Current") {
            DetailLabeledRow(label: "Stage", value: batch.stage.title)
            if let phase = batch.currentPhase, batch.stage == .stratifying {
                DetailLabeledRow(label: "Phase", value: phase.phaseType.title)
                if let temp = phase.temperatureLabel {
                    DetailLabeledRow(label: "Temperature", value: temp)
                }
                if let start = phase.startedAt, let days = phase.selectedDurationDays {
                    let elapsed = Calendar.current.dateComponents([.day], from: start, to: .now).day ?? 0
                    DetailLabeledRow(label: "Progress", value: "Day \(max(elapsed, 0)) / \(days)")
                }
                if !phase.mediumDescription.isEmpty {
                    DetailLabeledRow(label: "Medium", value: phase.mediumDescription)
                }
            }
            if let locationID = batch.locationID,
               let location = referenceData.locations.first(where: { $0.id == locationID }) {
                DetailLabeledRow(label: "Location", value: location.name)
            }
            if let soilMixID = batch.soilMixID,
               let mix = referenceData.soilMixes.first(where: { $0.id == soilMixID }) {
                DetailLabeledRow(label: "Soil mix", value: mix.name)
            }
            DetailLabeledRow(label: "Viable", value: "\(batch.viableSeedCount)")
            DetailLabeledRow(label: "Sown", value: "\(batch.sownSeedCount)")
            DetailLabeledRow(label: "Germinated", value: "\(batch.germinatedSeedCount)")
            DetailLabeledRow(label: "Surviving", value: "\(batch.survivingSeedlingCount)")
            DetailLabeledRow(label: "Selected", value: "\(batch.selectedTreeCount)")
            DetailLabeledRow(label: "Trees created", value: "\(batch.createdTreeIDs.count)")
        }
    }

    private func metrics(_ batch: SeedBatch) -> some View {
        DetailCard(title: "Propagation Results") {
            Text("\(batch.initialSeedCount) seeds")
                .font(FaloCardTypography.fieldValue)
            DetailLabeledRow(label: "Germination", value: SeedBatch.percentLabel(batch.germinationRate))
            DetailLabeledRow(label: "Seedling survival", value: SeedBatch.percentLabel(batch.survivalRate))
            DetailLabeledRow(label: "Seed → seedling", value: SeedBatch.percentLabel(batch.seedToSeedlingRate))
            DetailLabeledRow(label: "Seed → tree", value: SeedBatch.percentLabel(batch.seedToTreeRate))
        }
    }

    @ViewBuilder
    private func scientificVsUser(_ batch: SeedBatch) -> some View {
        if let phase = batch.currentPhase {
            DetailCard(title: "Time: advice vs your choice") {
                DetailLabeledRow(
                    label: "Advised time",
                    value: phase.recommendedDurationLabel ?? "Variable"
                )
                DetailLabeledRow(
                    label: "Your time",
                    value: phase.selectedDurationDays.map { "\($0) days" } ?? "Not set yet"
                )
                Text("How long stratification should run — catalog advice vs what you set.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if phase.isUserAdjustedDuration {
                    Text("Your adjusted duration is kept in history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                Button("Change Time…") { handle(.changeTime) }
                    .buttonStyle(.bordered)
            }
        } else if let profile {
            DetailCard(title: "Scientific recommendation") {
                DetailLabeledRow(label: "Treatment", value: profile.treatmentType.title)
                Text(profile.confidenceLevel.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func actions(_ batch: SeedBatch) -> some View {
        DetailCard(title: "Actions") {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                if batch.stage == .planned {
                    Button("Start Stratification") { handle(.startStratification) }
                    Button("Skip to Ready to Sow") { handle(.skipToReadyToSow) }
                }
                if batch.stage == .stratifying {
                    Button("Complete Current Phase") { handle(.completeCurrentPhase) }
                    Button("Change Time…") { handle(.changeTime) }
                    Button("Extend Phase +7 Days") { handle(.extendPhase) }
                }
                if batch.stage == .readyToSow || batch.stage == .stratifying {
                    Button("Record Sowing") { handle(.recordSowing) }
                }
                if batch.stage == .sown || batch.stage == .germinating {
                    Button("Record Germination") { handle(.recordGermination) }
                }
                if batch.stage == .germinating || batch.stage == .seedling || batch.stage == .developing {
                    Button("Update Survival") { handle(.updateSurvival) }
                    Button("Separate Seedlings") { handle(.separateSeedlings) }
                }
                if batch.stage == .developing || batch.stage == .seedling || batch.selectedTreeCount > batch.createdTreeIDs.count {
                    Button("Create Trees") { handle(.createTrees) }
                }
                Button("Mark Failed", role: .destructive) { handle(.markFailed) }
            }
        }
    }

    private func timeline(_ batch: SeedBatch) -> some View {
        DetailCard(title: "Timeline") {
            ForEach(batch.orderedEvents.reversed()) { event in
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.date.formatted(date: .abbreviated, time: .shortened))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(event.kind.title)
                        .font(FaloCardTypography.fieldValue)
                    if let quantity = event.quantity {
                        Text("Quantity: \(quantity)")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !event.notes.isEmpty {
                        Text(event.notes)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if event.isUserDecision {
                        Text("User decision")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, FaloSpacing.xSmall)
                Divider()
            }
        }
    }

    // MARK: Sheets

    private func startStratSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section("Medium") {
                    if seedSoilMixes.isEmpty {
                        Text("Optional. No Seeds mixes in inventory — paper towel, box, or other methods are fine. Describe them under Notes.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Soil mix", selection: $stratificationSoilMixID) {
                            Text("None").tag(UUID?.none)
                            ForEach(seedSoilMixes) { mix in
                                Text(mix.name).tag(Optional(mix.id))
                            }
                        }
                        Text("Optional — leave None for paper towel, box, or other methods.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Notes") {
                    TextField("How you stratify (e.g. paper in a plastic box)", text: $stratificationNotes, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("Location") {
                    Picker("Location", selection: $actionLocationID) {
                        Text("Keep current").tag(UUID?.none)
                        ForEach(referenceData.locations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                    if let profile {
                        Text("Recommended: \(profile.treatmentType.title)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Start Stratification")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showStartStrat = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        let mix = stratificationSoilMixID.flatMap { id in
                            seedSoilMixes.first(where: { $0.id == id })
                        }
                        run {
                            _ = try seedBatchService.startStratification(
                                batchID: batch.id,
                                mediumDescription: mix?.name ?? "",
                                locationID: actionLocationID ?? batch.locationID,
                                soilMixID: mix?.id,
                                notes: stratificationNotes
                            )
                            showStartStrat = false
                        }
                    }
                }
            }
            .onAppear {
                actionLocationID = batch.locationID
                stratificationNotes = ""
                // Do not auto-select a mix — None is a valid start.
                if stratificationSoilMixID != nil,
                   seedSoilMixes.contains(where: { $0.id == stratificationSoilMixID }) == false {
                    stratificationSoilMixID = nil
                }
            }
        }
        .frame(minWidth: 480, minHeight: 420)
    }

    private func changeTimeSheet(_ batch: SeedBatch) -> some View {
        let advised = batch.currentPhase?.recommendedDurationLabel ?? "Variable"
        return NavigationStack {
            Form {
                Section("Your time") {
                    TextField("Days", text: $changeTimeDays)
                    Text("Advised time: \(advised)")
                        .foregroundStyle(.secondary)
                }
                Section("Notes") {
                    TextField("Why you chose this length (optional)", text: $changeTimeNotes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Change Time")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showChangeTime = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let days = Int(changeTimeDays.trimmingCharacters(in: .whitespacesAndNewlines)),
                              days > 0 else {
                            errorMessage = "Enter a number of days (at least 1)."
                            return
                        }
                        run {
                            _ = try seedBatchService.setCurrentPhaseDuration(
                                batchID: batch.id,
                                days: days,
                                notes: changeTimeNotes
                            )
                            showChangeTime = false
                        }
                    }
                    .disabled(Int(changeTimeDays.trimmingCharacters(in: .whitespacesAndNewlines)).map { $0 < 1 } ?? true)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 320)
    }

    private func sowSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section("Sowing") {
                    TextField("Seeds sown", text: $sownCount)
                    if seedSoilMixes.isEmpty {
                        Text("No Seeds mixes yet. Create one under Inventory → Soil → Mixes and tag it Seeds.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Soil mix", selection: $soilMixID) {
                            Text("Select").tag(UUID?.none)
                            ForEach(seedSoilMixes) { mix in
                                Text(mix.name).tag(Optional(mix.id))
                            }
                        }
                    }
                    TextField("Container", text: $container)
                }
                Section("Location") {
                    Picker("Location", selection: $actionLocationID) {
                        Text("Keep current").tag(UUID?.none)
                        ForEach(referenceData.locations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Record Sowing")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showSow = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(sownCount) else {
                            errorMessage = "Enter sown count."
                            return
                        }
                        guard soilMixID != nil else {
                            errorMessage = "Select a Seeds soil mix."
                            return
                        }
                        run {
                            _ = try seedBatchService.recordSowing(
                                batchID: batch.id,
                                sownCount: count,
                                soilMixID: soilMixID,
                                locationID: actionLocationID ?? batch.locationID,
                                containerDescription: container,
                                sowingDepth: "",
                                notes: ""
                            )
                            showSow = false
                        }
                    }
                    .disabled(seedSoilMixes.isEmpty || soilMixID == nil)
                }
            }
            .onAppear {
                sownCount = "\(batch.viableSeedCount)"
                actionLocationID = batch.locationID
                if soilMixID == nil {
                    soilMixID = seedSoilMixes.first?.id
                }
            }
        }
        .frame(minWidth: 480, minHeight: 400)
    }

    private func germSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Total germinated (cumulative)", text: $germCount)
                    Text("Sown: \(batch.sownSeedCount). Enter the running total, not a delta.")
                        .foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Germination")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showGerm = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(germCount) else {
                            errorMessage = "Enter germination count."
                            return
                        }
                        run {
                            _ = try seedBatchService.recordGermination(batchID: batch.id, germinatedCount: count)
                            showGerm = false
                        }
                    }
                }
            }
            .onAppear { germCount = "\(batch.germinatedSeedCount)" }
        }
        .frame(minWidth: 480, minHeight: 280)
    }

    private func surviveSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Surviving seedlings", text: $survivingCount)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Survival")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showSurvive = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let count = Int(survivingCount) else {
                            errorMessage = "Enter surviving count."
                            return
                        }
                        run {
                            _ = try seedBatchService.recordSeedlingSurvival(batchID: batch.id, survivingCount: count)
                            showSurvive = false
                        }
                    }
                }
            }
            .onAppear { survivingCount = "\(batch.survivingSeedlingCount)" }
        }
        .frame(minWidth: 480, minHeight: 260)
    }

    private func separateSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Seedlings to select", text: $selectCount)
                    Text("Surviving in batch: \(batch.survivingSeedlingCount)")
                        .foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Separate Seedlings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showSeparate = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Separate") {
                        guard let count = Int(selectCount) else {
                            errorMessage = "Enter a count."
                            return
                        }
                        run {
                            _ = try seedBatchService.separateSeedlings(batchID: batch.id, selectCount: count)
                            showSeparate = false
                        }
                    }
                }
            }
        }
        .frame(minWidth: 480, minHeight: 280)
    }

    private func createTreesSheet(_ batch: SeedBatch) -> some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Number of trees", text: $createTreeCount)
                    Picker("Location", selection: $actionLocationID) {
                        Text("Select").tag(UUID?.none)
                        ForEach(referenceData.locations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                    Text("Creates N Tree records linked to \(batch.batchCode).")
                        .foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Create Trees")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showCreateTrees = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        guard let count = Int(createTreeCount), let locationID = actionLocationID ?? batch.locationID else {
                            errorMessage = "Enter count and location."
                            return
                        }
                        run {
                            _ = try seedBatchService.createTrees(
                                batchID: batch.id,
                                count: count,
                                locationID: locationID,
                                acquisitionMethodID: nil
                            )
                            showCreateTrees = false
                        }
                    }
                }
            }
            .onAppear {
                let remaining = max(batch.selectedTreeCount - batch.createdTreeIDs.count, 1)
                createTreeCount = "\(remaining)"
                actionLocationID = batch.locationID
            }
        }
        .frame(minWidth: 480, minHeight: 360)
    }

    private func run(_ work: () throws -> Void) {
        do {
            try work()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
