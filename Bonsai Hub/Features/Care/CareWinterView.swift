//
//  CareWinterView.swift
//  Bonsai World
//
//  Care → Winter Care — Seasonal storage checklist with multi-select per step,
//  plus frost advice and Tasks sync (system Task title: Winter Care).
//

import SwiftUI

struct CareWinterView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(WeatherService.self) private var weatherService
    @Environment(WinterCareService.self) private var winterCare
    @Environment(GrowingIntelligenceService.self) private var growingIntelligence
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(UserProfileStore.self) private var profile
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.scenePhase) private var scenePhase

    @State private var selectedStep: WinterCareStep = .washPot
    @State private var selectedTreeIDs: Set<UUID> = []
    @State private var statusMessage: String?
    @State private var errorMessage: String?

    private var snapshot: WeatherSnapshot? { weatherService.snapshot }

    private var isActive: Bool {
        winterCare.isWinterCareActive(snapshot: snapshot)
    }

    private var pendingForStep: [Tree] {
        winterCare.treesPending(step: selectedStep, snapshot: snapshot)
    }

    private var winterAdviceGroups: [WinterLocationAdviceGroup] {
        guard let snapshot,
              let defaultGardenID = profile.defaultGarden?.id
        else { return [] }

        let trees = treeService.trees.filter(\.isInCare)
        var locationIDs: [UUID] = []
        var seen = Set<UUID>()
        for tree in trees where seen.insert(tree.locationID).inserted {
            locationIDs.append(tree.locationID)
        }

        var groups: [WinterLocationAdviceGroup] = []
        for locationID in locationIDs {
            guard let location = referenceData.location(id: locationID),
                  location.gardenID == defaultGardenID
            else { continue }
            let advice = growingIntelligence.winterAdvice(
                environment: location.environment,
                snapshot: snapshot
            )
            guard advice.hasContent else { continue }
            groups.append(
                WinterLocationAdviceGroup(
                    id: location.id,
                    locationName: location.name,
                    lines: advice.lines
                )
            )
        }
        return groups
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.recommendationActiveLine)
                seasonBanner
                if !winterAdviceGroups.isEmpty {
                    winterAdviceCard
                }
                checklistCard
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 1100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Winter Care")
        .task {
            await weatherService.refreshIfNeeded()
            try? winterCare.syncWinterCareTask(snapshot: snapshot)
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task {
                await weatherService.refreshIfNeeded()
                try? winterCare.syncWinterCareTask(snapshot: weatherService.snapshot)
            }
        }
        .onChange(of: selectedStep) { _, _ in
            selectedTreeIDs = []
        }
        .alert(
            "Couldn't Update Winter Care",
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

    private var seasonBanner: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            if isActive {
                Text("Winter Care is active — seasonal trees still on Summer placement. Select several trees, then mark the step done. Where the tree stands (Location) is separate — update it when you move.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                Text("Winter Care starts on \(reminderLabel) or when the night low reaches \(frostLabel). Set Placement strategy to Seasonal and Season to Summer placement on each tree.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            }
            if let statusMessage {
                Text(statusMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var reminderLabel: String {
        let month = appSettings.winterCareReminderMonth
        let day = appSettings.winterCareReminderDay
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = 2000
        if let date = Calendar.current.date(from: components) {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
        return "\(month)/\(day)"
    }

    private var frostLabel: String {
        let unit = appSettings.temperatureUnit
        return unit.formatted(celsius: appSettings.winterCareFrostCelsius)
    }

    @ViewBuilder
    private var winterAdviceCard: some View {
        let groups = winterAdviceGroups
        DetailCard(title: "Frost Advice") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                ForEach(groups) { group in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        if groups.count > 1 {
                            Text(group.locationName)
                                .font(FaloCardTypography.fieldLabel)
                                .foregroundStyle(.secondary)
                        }
                        ForEach(group.lines, id: \.self) { line in
                            Label(line, systemImage: "exclamationmark.triangle.fill")
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.statusAttention)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var checklistCard: some View {
        DetailCard(title: WinterCareService.taskTitle) {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                Picker("Step", selection: $selectedStep) {
                    ForEach(WinterCareStep.allCases) { step in
                        Text(step.title).tag(step)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 360, alignment: .leading)

                Text(selectedStep.help)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                if !isActive {
                    Text("No checklist until Winter Care is active.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else if pendingForStep.isEmpty {
                    Text("Nothing left for this step.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else {
                    HStack {
                        Button(selectedTreeIDs.count == pendingForStep.count ? "Deselect All" : "Select All") {
                            if selectedTreeIDs.count == pendingForStep.count {
                                selectedTreeIDs = []
                            } else {
                                selectedTreeIDs = Set(pendingForStep.map(\.id))
                            }
                        }
                        .buttonStyle(.borderless)

                        Spacer()

                        Button("Mark Step Done for Selected") {
                            markSelectedDone()
                        }
                        .disabled(selectedTreeIDs.isEmpty)
                    }

                    VStack(spacing: 0) {
                        ForEach(Array(pendingForStep.enumerated()), id: \.element.id) { index, tree in
                            treeRow(tree)
                            if index < pendingForStep.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func treeRow(_ tree: Tree) -> some View {
        let isSelected = selectedTreeIDs.contains(tree.id)
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            Button {
                if isSelected {
                    selectedTreeIDs.remove(tree.id)
                } else {
                    selectedTreeIDs.insert(tree.id)
                }
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarAccent : .secondary)
            }
            .buttonStyle(.plain)

            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(TreePresentation.title(for: tree))
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(remainingStepsLabel(for: tree))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Open") {
                appState.showTreeFromMap(treeID: tree.id)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func remainingStepsLabel(for tree: Tree) -> String {
        let left = winterCare.incompleteSteps(for: tree)
        if left.isEmpty { return "All steps done" }
        return "Still: " + left.map(\.title).joined(separator: " · ")
    }

    private func markSelectedDone() {
        let ids = Array(selectedTreeIDs)
        do {
            try winterCare.complete(step: selectedStep, for: ids, snapshot: snapshot)
            selectedTreeIDs = []
            statusMessage = "Marked \(selectedStep.title) done for \(ids.count) tree\(ids.count == 1 ? "" : "s")."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct WinterLocationAdviceGroup: Identifiable, Hashable {
    let id: UUID
    let locationName: String
    let lines: [String]
}
