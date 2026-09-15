//
//  CareWateringView.swift
//  Bonsai World
//
//  Care → Watering — due watering from Tasks, recent Work, instant register.
//  Weather / Heat watch lines come from WateringEngine (info only).
//

import SwiftUI

struct CareWateringView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(UserProfileStore.self) private var profile
    @Environment(WeatherService.self) private var weatherService
    @Environment(GrowingIntelligenceService.self) private var growingIntelligence
    @Environment(\.scenePhase) private var scenePhase

    @State private var isPickTreePresented = false
    @State private var isAddTaskPresented = false
    @State private var statusMessage: String?
    @State private var errorMessage: String?

    private var needsOccurrences: [TaskOccurrence] {
        taskService.pendingWateringOccurrences(due: .today)
            .filter {
                guard let treeID = $0.treeID else { return false }
                return treeService.effectiveWateringPolicy(for: treeID).mode == .remind
            }
    }

    private var hiddenDueCount: Int {
        let all = taskService.pendingWateringOccurrences(due: .today)
        return max(0, all.count - needsOccurrences.count)
    }

    private var recentWaterings: [WorkRecord] {
        workService.recentWateringRecords()
    }

    private var inCareTrees: [Tree] {
        treeService.trees
            .filter(\.isInCare)
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    private var wateringWorkTypeID: UUID? {
        workService.preferredWateringWorkTypeID()
    }

    /// Location-scoped WateringEngine advice for Remind trees (default Garden weather only).
    private var wateringLocationRiskGroups: [WateringLocationRiskGroup] {
        guard let snapshot = weatherService.snapshot,
              let defaultGardenID = profile.defaultGarden?.id
        else { return [] }

        let treeIDs = wateringRiskTreeIDs
        var locationIDs: [UUID] = []
        var seenLocation = Set<UUID>()
        for treeID in treeIDs {
            guard let tree = treeService.getTree(id: treeID) else { continue }
            if seenLocation.insert(tree.locationID).inserted {
                locationIDs.append(tree.locationID)
            }
        }

        var groups: [WateringLocationRiskGroup] = []
        for locationID in locationIDs {
            guard let location = referenceData.location(id: locationID),
                  location.gardenID == defaultGardenID
            else { continue }
            let heatWatch = heatWatchEnabled(forLocationID: locationID, among: treeIDs)
            let advice = growingIntelligence.wateringAdvice(
                environment: location.environment,
                snapshot: snapshot,
                heatWatchEnabled: heatWatch
            )
            guard advice.hasContent else { continue }
            groups.append(
                WateringLocationRiskGroup(
                    id: location.id,
                    locationName: location.name,
                    risks: advice.lines,
                    heatWatchActive: advice.heatWatchActive
                )
            )
        }
        return groups
    }

    /// Prefer Due Today trees; if none, in-care Remind trees so heat still surfaces.
    private var wateringRiskTreeIDs: [UUID] {
        let dueIDs = needsOccurrences.compactMap(\.treeID)
        if !dueIDs.isEmpty { return dueIDs }
        return inCareTrees
            .filter { treeService.effectiveWateringPolicy(for: $0.id).mode == .remind }
            .map(\.id)
    }

    private func heatWatchEnabled(forLocationID locationID: UUID, among treeIDs: [UUID]) -> Bool {
        for treeID in treeIDs {
            guard let tree = treeService.getTree(id: treeID), tree.locationID == locationID else { continue }
            if treeService.effectiveWateringPolicy(for: treeID).heatWatchEnabled {
                return true
            }
        }
        return false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.recommendationActiveLine)
                headerActions

                if let statusMessage {
                    Text(statusMessage)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                CareTwoColumnLayout {
                    weatherRisksCard
                    needsCard
                } secondary: {
                    recentCard
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 1100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Watering")
        .task {
            await weatherService.refreshIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await weatherService.refreshIfNeeded() }
        }
        .sheet(isPresented: $isPickTreePresented) {
            NavigationStack {
                treePicker
            }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                AddTaskSheet(preselectedWorkTypeID: wateringWorkTypeID)
            }
        }
        .alert(
            "Couldn't Register Watering",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    @ViewBuilder
    private var weatherRisksCard: some View {
        let groups = wateringLocationRiskGroups
        if !groups.isEmpty {
            DetailCard(title: "Weather") {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    ForEach(groups) { group in
                        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                            if groups.count > 1 {
                                Text(group.locationName)
                                    .font(FaloCardTypography.fieldLabel)
                                    .foregroundStyle(.secondary)
                            }
                            if group.heatWatchActive {
                                Label("Heat watch", systemImage: "sun.max.fill")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(BonsaiWorldColors.statusAttention)
                            }
                            ForEach(group.risks, id: \.self) { risk in
                                Label(risk, systemImage: "exclamationmark.triangle.fill")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(BonsaiWorldColors.statusAttention)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Due from Tasks (Remind only). Register as Work. Add Task opens the Tasks sheet.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(wateringWorkTypeID == nil)
                .help(
                    wateringWorkTypeID == nil
                        ? "Add a Watering Work Type in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Water All Due") {
                    waterAllDue()
                }
                .disabled(needsOccurrences.isEmpty)

                Button("Register Watering…") {
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || wateringWorkTypeID == nil)
                .help(
                    wateringWorkTypeID == nil
                        ? "Add a Watering Work Type in Reference Data."
                        : "Choose a tree and register watering now"
                )
            }
        }
    }

    private var needsCard: some View {
        DetailCard(title: "Due Today") {
            if needsOccurrences.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Nothing due today.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Remind trees appear here. Set Remind on a Collection’s Watering policy, or Add Task…")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                    if hiddenDueCount > 0 {
                        Text("\(hiddenDueCount) watering task\(hiddenDueCount == 1 ? "" : "s") hidden (Silent or Auto-watered).")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(needsOccurrences.enumerated()), id: \.element.id) { index, occurrence in
                        needsRow(occurrence)
                        if index < needsOccurrences.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var recentCard: some View {
        DetailCard(title: "Recent Watering") {
            if recentWaterings.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No watering Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Use Register Watering… or Water on a due row — it writes to the tree’s history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentWaterings.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < recentWaterings.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func needsRow(_ occurrence: TaskOccurrence) -> some View {
        let treeID = occurrence.treeID
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: tree?.listImageID,
                imageService: imageService
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)

                Text(occurrence.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let tree, let context = locationWateringContext(for: tree) {
                    Text(context)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(2)
                }

                if let treeID, showsHeatWatch(for: treeID) {
                    Label("Heat watch", systemImage: "sun.max.fill")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.statusAttention)
                        .labelStyle(.titleAndIcon)
                }

                if let treeID {
                    Text(lastWateredLabel(for: treeID))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Water") {
                water(occurrence)
            }
            .disabled(!occurrence.isInstant || treeID == nil)

            Button("Open") {
                if let treeID { appState.showTreeFromMap(treeID: treeID) }
            }
            .buttonStyle(.borderless)
            .disabled(treeID == nil)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    /// Compact Location environment line — same fields as Location Detail Environment.
    private func locationWateringContext(for tree: Tree) -> String? {
        guard let location = referenceData.location(id: tree.locationID) else { return nil }
        let environment = location.environment
        var parts: [String] = []

        let name = location.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            parts.append(name)
        }
        if let setting = environment.setting {
            parts.append(setting.title)
        }
        if let shade = environment.shadeLevel {
            parts.append(shade.title)
        }
        if let wind = environment.windExposure {
            parts.append(wind.title)
        }
        if let rain = environment.rainExposure {
            parts.append(rain.title)
        }
        let methods = environment.wateringMethods
            .sorted { $0.title < $1.title }
            .map(\.title)
        if !methods.isEmpty {
            parts.append(methods.joined(separator: ", "))
        }

        guard !parts.isEmpty else { return nil }
        return parts.joined(separator: " · ")
    }

    private func showsHeatWatch(for treeID: UUID) -> Bool {
        guard treeService.effectiveWateringPolicy(for: treeID).heatWatchEnabled else { return false }
        guard let tree = treeService.getTree(id: treeID),
              let location = referenceData.location(id: tree.locationID)
        else { return false }
        return growingIntelligence.wateringAdvice(
            environment: location.environment,
            snapshot: weatherService.snapshot,
            heatWatchEnabled: true
        ).heatWatchActive
    }

    @ViewBuilder
    private func recentRow(_ record: WorkRecord) -> some View {
        let treeID = record.treeIDs.first
        let tree = treeID.flatMap { treeService.getTree(id: $0) }
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: tree?.listImageID,
                imageService: imageService
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(tree.map { TreePresentation.title(for: $0) } ?? "Unknown Tree")
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)

                Text(record.performedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let treeID {
                Button("Open") {
                    appState.showTreeFromMap(treeID: treeID)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var treePicker: some View {
        List {
            ForEach(inCareTrees) { tree in
                Button {
                    isPickTreePresented = false
                    registerWatering(for: tree.id)
                } label: {
                    HStack(spacing: FaloSpacing.medium) {
                        TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(TreePresentation.title(for: tree))
                            Text(lastWateredLabel(for: tree.id))
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Choose Tree")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { isPickTreePresented = false }
            }
        }
        .frame(minWidth: 360, minHeight: 420)
    }

    private func lastWateredLabel(for treeID: UUID) -> String {
        if let date = workService.lastCompletedWateringDate(for: treeID) {
            return "Last watered \(date.formatted(date: .abbreviated, time: .shortened))"
        }
        return "No watering Work yet"
    }

    private func water(_ occurrence: TaskOccurrence) {
        do {
            let result = try taskService.completeOccurrenceInstantly(occurrence)
            statusMessage = completionMessage(for: result)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func waterAllDue() {
        var completed = 0
        for occurrence in needsOccurrences where occurrence.isInstant {
            if (try? taskService.completeOccurrenceInstantly(occurrence)) != nil {
                completed += 1
            }
        }
        statusMessage = completed == 0
            ? "Nothing completed."
            : "Watered \(completed) tree\(completed == 1 ? "" : "s")."
    }

    private func registerWatering(for treeID: UUID) {
        guard let workTypeID = wateringWorkTypeID else {
            errorMessage = "Add a Watering Work Type in Reference Data."
            return
        }
        do {
            _ = try workService.registerWork(
                workTypeID: workTypeID,
                treeIDs: [treeID]
            )
            let title = treeService.getTree(id: treeID).map { TreePresentation.title(for: $0) } ?? "Tree"
            statusMessage = "Watered “\(title)”."
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func completionMessage(for result: TaskService.OccurrenceCompletionResult) -> String {
        guard let nextDueDate = result.nextDueDate else {
            return "Watered “\(result.occurrenceTitle)”."
        }
        let dateText = nextDueDate.formatted(date: .abbreviated, time: .omitted)
        if let dayPart = result.nextDueDayPart {
            return "Watered “\(result.occurrenceTitle)”. Next due \(dayPart.title.lowercased()), \(dateText)."
        }
        return "Watered “\(result.occurrenceTitle)”. Next due \(dateText)."
    }
}

private struct WateringLocationRiskGroup: Identifiable, Hashable {
    let id: UUID
    let locationName: String
    let risks: [String]
    var heatWatchActive: Bool = false
}
