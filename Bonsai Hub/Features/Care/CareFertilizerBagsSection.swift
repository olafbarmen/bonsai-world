//
//  CareFertilizerBagsSection.swift
//  Bonsai World
//
//  Care → Fertilizing — fertilizer bags batch: enroll trees, replace when due,
//  interval editable (default 6 weeks).
//

import SwiftUI

struct CareFertilizerBagsSection: View {
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(FertilizerBagsService.self) private var bags
    @Environment(ImageService.self) private var imageService

    @State private var selectedDueIDs: Set<UUID> = []
    @State private var isEnrollPresented = false
    @State private var enrollSelection: Set<UUID> = []
    @State private var errorMessage: String?

    private var dueTrees: [Tree] { bags.treesDueForReplace() }
    private var enrolledNotDue: [Tree] {
        bags.enrolledTrees().filter { !bags.isDue($0) }
    }

    var body: some View {
        @Bindable var appSettings = appSettings

        DetailCard(title: "Bags") {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                Text("Place bags on several trees, then replace them together when due. Change the interval below or in Settings → Notifications.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                Stepper(
                    value: $appSettings.fertilizerBagsIntervalWeeks,
                    in: 1...26,
                    step: 1
                ) {
                    Text("Replace every \(appSettings.fertilizerBagsIntervalWeeks) week\(appSettings.fertilizerBagsIntervalWeeks == 1 ? "" : "s")")
                        .font(FaloCardTypography.fieldValue)
                }
                .frame(maxWidth: 420, alignment: .leading)

                HStack {
                    Button("Add trees to bags…") {
                        enrollSelection = []
                        isEnrollPresented = true
                    }
                    .disabled(bags.treesNotEnrolled().isEmpty)

                    Spacer()

                    if !dueTrees.isEmpty {
                        Button(selectedDueIDs.count == dueTrees.count ? "Deselect All" : "Select All") {
                            if selectedDueIDs.count == dueTrees.count {
                                selectedDueIDs = []
                            } else {
                                selectedDueIDs = Set(dueTrees.map(\.id))
                            }
                        }
                        .buttonStyle(.borderless)

                        Button("Mark bags replaced") {
                            markSelectedReplaced()
                        }
                        .disabled(selectedDueIDs.isEmpty)
                    }
                }

                if dueTrees.isEmpty, bags.enrolledTrees().isEmpty {
                    Text("No trees on fertilizer bags yet. Add trees when you place bags.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else if dueTrees.isEmpty {
                    Text("No bags due right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(dueTrees.enumerated()), id: \.element.id) { index, tree in
                            dueRow(tree)
                            if index < dueTrees.count - 1 {
                                Divider()
                            }
                        }
                    }
                }

                if !enrolledNotDue.isEmpty {
                    Text("On bags — next replace later")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    VStack(spacing: 0) {
                        ForEach(Array(enrolledNotDue.enumerated()), id: \.element.id) { index, tree in
                            enrolledRow(tree)
                            if index < enrolledNotDue.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEnrollPresented) {
            enrollSheet
        }
        .alert(
            "Couldn't Update Fertilizer Bags",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .onChange(of: appSettings.fertilizerBagsIntervalWeeks) { _, _ in
            try? bags.syncFertilizerBagsTask()
        }
    }

    @ViewBuilder
    private func dueRow(_ tree: Tree) -> some View {
        let isSelected = selectedDueIDs.contains(tree.id)
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            Button {
                if isSelected {
                    selectedDueIDs.remove(tree.id)
                } else {
                    selectedDueIDs.insert(tree.id)
                }
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarAccent : .secondary)
            }
            .buttonStyle(.plain)

            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(TreePresentation.registryName(for: tree))
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(dueSubtitle(for: tree))
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

    @ViewBuilder
    private func enrolledRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

            VStack(alignment: .leading, spacing: 2) {
                Text(TreePresentation.registryName(for: tree))
                    .font(FaloCardTypography.fieldValue)
                    .lineLimit(1)
                Text(enrolledSubtitle(for: tree))
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Stop bags") {
                do {
                    try bags.stopBags(on: [tree.id])
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            .buttonStyle(.borderless)

            Button("Open") {
                appState.showTreeFromMap(treeID: tree.id)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var enrollSheet: some View {
        let candidates = bags.treesNotEnrolled()
        return NavigationStack {
            List(selection: $enrollSelection) {
                ForEach(candidates) { tree in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(TreePresentation.registryName(for: tree))
                        if let botanical = TreePresentation.registrySubtitle(for: tree) {
                            Text(botanical)
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tag(tree.id)
                }
            }
            .navigationTitle("Add trees to bags")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isEnrollPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start bags") {
                        do {
                            try bags.startBags(on: Array(enrollSelection))
                            isEnrollPresented = false
                            enrollSelection = []
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                    .disabled(enrollSelection.isEmpty)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 480)
    }

    private func markSelectedReplaced() {
        let ids = Array(selectedDueIDs)
        do {
            try bags.markBagsReplaced(for: ids)
            selectedDueIDs = []
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func dueSubtitle(for tree: Tree) -> String {
        var parts: [String] = []
        if let botanical = TreePresentation.registrySubtitle(for: tree) {
            parts.append(botanical)
        }
        if let last = tree.lastFertilizerBagReplacedAt {
            parts.append("Last replaced \(last.formatted(date: .abbreviated, time: .omitted))")
        }
        return parts.joined(separator: " · ")
    }

    private func enrolledSubtitle(for tree: Tree) -> String {
        var parts: [String] = []
        if let botanical = TreePresentation.registrySubtitle(for: tree) {
            parts.append(botanical)
        }
        if let next = bags.nextReplaceDate(for: tree) {
            parts.append("Next \(next.formatted(date: .abbreviated, time: .omitted))")
        }
        return parts.joined(separator: " · ")
    }
}
