//
//  CareSpringView.swift
//  Bonsai World
//
//  Care → Spring Care — date-only return to summer placement for seasonal trees,
//  plus greenhouse heat / vent check for Locations (AE1 / AF1).
//

import SwiftUI

struct CareSpringView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(SpringCareService.self) private var springCare
    @Environment(GreenhouseCareService.self) private var greenhouseCare
    @Environment(AppSettings.self) private var appSettings
    @Environment(ReferenceDataManager.self) private var referenceDataManager

    @State private var selectedStep: SpringCareStep = .moveToSummerPlacement
    @State private var selectedTreeIDs: Set<UUID> = []
    @State private var selectedLocationIDs: Set<UUID> = []
    @State private var statusMessage: String?
    @State private var errorMessage: String?

    private var isActive: Bool { springCare.isSpringCareActive() }
    private var isGreenhouseActive: Bool { greenhouseCare.isGreenhouseSpringCheckActive() }

    private var pendingForStep: [Tree] {
        springCare.treesPending(step: selectedStep)
    }

    private var pendingGreenhouses: [LocationReference] {
        _ = referenceDataManager.revision
        return greenhouseCare.locationsNeedingCheck()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.recommendationActiveLine)
                seasonBanner
                checklistCard
                greenhouseCard
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 1100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Spring Care")
        .task {
            try? springCare.syncSpringCareTask()
            try? greenhouseCare.syncGreenhouseSpringCheckTask()
        }
        .onChange(of: selectedStep) { _, _ in
            selectedTreeIDs = []
        }
        .alert(
            "Couldn't Update Spring Care",
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
                Text("Spring Care is active — seasonal trees still on Winter placement. Select several trees, then mark the step done. Update Location after you move them.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                Text("Spring Care starts on \(reminderLabel) (date only — no temperature). Set Placement strategy to Seasonal and Season to Winter placement on trees that should move out.")
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
        var components = DateComponents()
        components.month = appSettings.springCareReminderMonth
        components.day = appSettings.springCareReminderDay
        components.year = 2000
        if let date = Calendar.current.date(from: components) {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
        return "\(appSettings.springCareReminderMonth)/\(appSettings.springCareReminderDay)"
    }

    private var checklistCard: some View {
        DetailCard(title: SpringCareService.taskTitle) {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                ForEach(SpringCareStep.allCases) { step in
                    Text(step.title)
                        .font(FaloTypography.headline)
                    Text(step.help)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                if !isActive {
                    Text("No checklist until Spring Care is active.")
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
                Text(tree.seasonPlacement.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Open") {
                appState.showTreeFromMap(treeID: tree.id)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var greenhouseReminderLabel: String {
        var components = DateComponents()
        components.month = appSettings.greenhouseSpringReminderMonth
        components.day = appSettings.greenhouseSpringReminderDay
        components.year = 2000
        if let date = Calendar.current.date(from: components) {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
        return "\(appSettings.greenhouseSpringReminderMonth)/\(appSettings.greenhouseSpringReminderDay)"
    }

    private var greenhouseCard: some View {
        DetailCard(title: GreenhouseCareService.taskTitle) {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                Text("For Locations set to Greenhouse, Cold Greenhouse, or Polytunnel. Date only — check heat and unlock vents.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                if !isGreenhouseActive {
                    Text("Starts on \(greenhouseReminderLabel) (Settings → Notifications). Set Location Setting under Growing → Locations.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else if pendingGreenhouses.isEmpty {
                    Text("All greenhouse locations checked for this spring.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else {
                    HStack {
                        Button(selectedLocationIDs.count == pendingGreenhouses.count ? "Deselect All" : "Select All") {
                            if selectedLocationIDs.count == pendingGreenhouses.count {
                                selectedLocationIDs = []
                            } else {
                                selectedLocationIDs = Set(pendingGreenhouses.map(\.id))
                            }
                        }
                        .buttonStyle(.borderless)

                        Spacer()

                        Button("Mark Checked for Selected") {
                            markGreenhousesChecked()
                        }
                        .disabled(selectedLocationIDs.isEmpty)
                    }

                    VStack(spacing: 0) {
                        ForEach(Array(pendingGreenhouses.enumerated()), id: \.element.id) { index, location in
                            locationRow(location)
                            if index < pendingGreenhouses.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func locationRow(_ location: LocationReference) -> some View {
        let isSelected = selectedLocationIDs.contains(location.id)
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            Button {
                if isSelected {
                    selectedLocationIDs.remove(location.id)
                } else {
                    selectedLocationIDs.insert(location.id)
                }
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarAccent : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(location.name)
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(location.environment.setting?.title ?? "Greenhouse")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func markSelectedDone() {
        let ids = Array(selectedTreeIDs)
        do {
            try springCare.complete(step: selectedStep, for: ids)
            selectedTreeIDs = []
            statusMessage = "Marked \(selectedStep.title) done for \(ids.count) tree\(ids.count == 1 ? "" : "s")."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func markGreenhousesChecked() {
        let ids = Array(selectedLocationIDs)
        do {
            try greenhouseCare.completeCheck(for: ids)
            selectedLocationIDs = []
            statusMessage = "Marked greenhouse check done for \(ids.count) location\(ids.count == 1 ? "" : "s")."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
