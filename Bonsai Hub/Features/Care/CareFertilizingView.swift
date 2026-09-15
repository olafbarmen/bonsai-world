//
//  CareFertilizingView.swift
//  Bonsai World
//
//  Care → Fertilizing — guidance (decision engine) + act on Tasks due + register Work.
//  Add Task opens the same Tasks sheet (no separate Care task engine).
//  No SwiftUI #Preview here — environment graph is heavy; use the live Care module.
//

import SwiftUI

struct CareFertilizingView: View {
    @Environment(AppState.self) private var appState
    @Environment(GrowingIntelligenceService.self) private var growingIntelligence
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(InventoryStockService.self) private var inventoryStock

    @State private var kind: FertilizerKind = .juniper
    @State private var stage: FertilizerStage = .development
    @State private var health: FertilizerHealth = .healthy
    @State private var season: FertilizerSeason = .spring
    @State private var growth: FertilizerGrowth = .activeExtension

    @State private var registerTreeID: UUID?
    @State private var registerFertilizerTypeID: UUID?
    @State private var isRegisterPresented = false
    @State private var isPickTreePresented = false
    @State private var isAddTaskPresented = false
    /// When set, tree picker is for registering with this Fertilizer Type pre-selected.
    @State private var pendingFertilizerTypeID: UUID?

    private var advice: FertilizerAdvice {
        growingIntelligence.fertilizerAdvice(
            FertilizerQuery(
                kind: kind,
                stage: stage,
                season: season,
                growth: growth,
                health: health
            )
        )
    }

    private var needsOccurrences: [TaskOccurrence] {
        taskService.pendingFertilizingOccurrences()
    }

    private var recentFertilizings: [WorkRecord] {
        workService.recentFertilizingRecords()
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

    private var fertilizingWorkTypeID: UUID? {
        workService.preferredFertilizingWorkTypeID()
    }

    private var matchedCatalogRows: [CareFertilizerCatalogRow] {
        let types = FertilizerCatalogMatcher.matchingTypes(
            from: referenceData.fertilizerTypes,
            category: advice.category
        )
        var stockByCatalog: [UUID: [InventoryStockItem]] = [:]
        for item in inventoryStock.items(for: .fertilizer) where item.quantity > 0 {
            guard let catalogID = item.catalogItemID else { continue }
            stockByCatalog[catalogID, default: []].append(item)
        }

        return types.map { type in
            let stock = (stockByCatalog[type.id] ?? []).sorted {
                $0.quantity > $1.quantity
            }
            return CareFertilizerCatalogRow(fertilizer: type, stockItems: stock)
        }
        .sorted { lhs, rhs in
            if lhs.inStock != rhs.inStock { return lhs.inStock && !rhs.inStock }
            return lhs.fertilizer.displayName.localizedCaseInsensitiveCompare(
                rhs.fertilizer.displayName
            ) == .orderedAscending
        }
    }

    private var adviceNotesForTask: String {
        var lines = [
            advice.summary,
            "Strength: \(advice.strength)",
            "When: \(advice.whenToStart)",
            "Fertilizer: \(advice.fertilizerLine)"
        ]
        if let rhythm = advice.rhythm {
            lines.append("Rhythm: \(rhythm)")
        }
        lines.append("Caution: \(advice.caution)")
        return lines.joined(separator: "\n")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                CareHonestyLine(text: CareHonesty.recommendationActiveLine)
                headerActions

                CareTwoColumnLayout {
                    needsCard
                } secondary: {
                    pickerCard
                    recommendationCard
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
        .bonsaiWorkspaceNavigationTitle("Fertilizing")
        .sheet(isPresented: $isRegisterPresented) {
            if let treeID = registerTreeID {
                NavigationStack {
                    AddWorkSheet(
                        treeID: treeID,
                        initialWorkTypeID: fertilizingWorkTypeID,
                        initialFertilizerTypeID: registerFertilizerTypeID
                    )
                }
            }
        }
        .onChange(of: isRegisterPresented) { _, presented in
            if !presented {
                registerTreeID = nil
                registerFertilizerTypeID = nil
            }
        }
        .sheet(isPresented: $isPickTreePresented) {
            NavigationStack {
                treePicker
            }
        }
        .onChange(of: isPickTreePresented) { _, presented in
            if !presented { pendingFertilizerTypeID = nil }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                AddTaskSheet(
                    preselectedWorkTypeID: fertilizingWorkTypeID,
                    prefillTitle: "Fertilizing",
                    prefillNotes: adviceNotesForTask
                )
            }
        }
    }

    private var headerActions: some View {
        HStack(alignment: .top) {
            Text("Due from Tasks. Register as Work. Guidance below. Add Task opens the Tasks sheet.")
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: FaloSpacing.small) {
                Button("Add Task…") {
                    isAddTaskPresented = true
                }
                .disabled(fertilizingWorkTypeID == nil)
                .help(
                    fertilizingWorkTypeID == nil
                        ? "Add a Fertilizing Work Type in Reference Data."
                        : "Create a Task or Schedule (same as Tasks → Add Task)"
                )

                Button("Register Fertilizing…") {
                    pendingFertilizerTypeID = nil
                    isPickTreePresented = true
                }
                .disabled(inCareTrees.isEmpty || fertilizingWorkTypeID == nil)
                .help(
                    fertilizingWorkTypeID == nil
                        ? "Add a Fertilizing Work Type in Reference Data."
                        : "Choose a tree, then register Fertilizing Work"
                )
            }
        }
    }

    private var needsCard: some View {
        DetailCard(title: "Needs Fertilizing") {
            if needsOccurrences.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Nothing due right now.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Add Task… when you plan fertilizing — it will show here from Tasks.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
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
        DetailCard(title: "Recent Fertilizing") {
            if recentFertilizings.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("No fertilizing Work yet.")
                        .font(FaloCardTypography.fieldValue)
                        .foregroundStyle(.secondary)
                    Text("Use Register Fertilizing… or Register on a due row — it writes to the tree’s history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentFertilizings.enumerated()), id: \.element.id) { index, record in
                        recentRow(record)
                        if index < recentFertilizings.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private var pickerCard: some View {
        DetailCard(title: "Guidance") {
            Text(FertilizerGuides.openingLine)
                .font(FaloTypography.body)
                .padding(.bottom, FaloSpacing.small)

            lookupPicker("Kind of tree", selection: $kind) {
                ForEach(FertilizerKind.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            lookupPicker("Stage", selection: $stage) {
                ForEach(FertilizerStage.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            lookupPicker("Health", selection: $health) {
                ForEach(FertilizerHealth.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            lookupPicker("Season", selection: $season) {
                ForEach(FertilizerSeason.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            lookupPicker("What the tree is doing", selection: $growth) {
                ForEach(FertilizerGrowth.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
        }
    }

    private var recommendationCard: some View {
        DetailCard(title: "Recommendation") {
            Text(advice.summary)
                .font(FaloCardTypography.fieldValue)
                .padding(.bottom, FaloSpacing.small)

            adviceRow("Why", advice.explanation)
            adviceRow("Goal", advice.goal)
            adviceRow("Strength", advice.strength)
            adviceRow("When", advice.whenToStart)
            adviceRow("Fertilizer", advice.fertilizerLine)
            if let rhythm = advice.rhythm {
                adviceRow("Rhythm", rhythm)
            }
            adviceRow("Seaweed", advice.seaweed)
            adviceRow("Humic & micronutrients", advice.humic)
            adviceRow("Caution", advice.caution)

            catalogMatchesBlock

            Text(FertilizerAdvice.followTheLabel)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .padding(.top, FaloSpacing.small)

            Button("Open Fertilizer Guides") {
                appState.selectSection(.knowledgeFertilizerGuides)
            }
            .buttonStyle(.borderless)
            .font(FaloTypography.caption)
            .padding(.top, FaloSpacing.small)
        }
    }

    @ViewBuilder
    private var catalogMatchesBlock: some View {
        let rows = matchedCatalogRows
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Fertilizer Types")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
                .padding(.top, FaloSpacing.small)

            if advice.category == .none {
                Text("No fertilizer recommended for this guidance.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            } else if rows.isEmpty {
                Text("No matching Fertilizer Types. Add products in Settings → Reference Data → Fertilizer Types.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            } else {
                Text("In stock first. Tap to Register Fertilizing.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)

                ForEach(rows) { row in
                    Button {
                        beginRegister(withFertilizerTypeID: row.id)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(row.fertilizer.displayName)
                                    .font(FaloCardTypography.fieldValue)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Text(row.subtitle)
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer(minLength: 0)
                            Text(row.inStock ? "In stock" : "Not in stock")
                                .font(FaloTypography.caption)
                                .foregroundStyle(
                                    row.inStock
                                        ? BonsaiWorldColors.statusAttention
                                        : BonsaiWorldColors.textSecondary
                                )
                        }
                        .padding(.vertical, FaloSpacing.xSmall)
                    }
                    .buttonStyle(.plain)
                    .disabled(inCareTrees.isEmpty || fertilizingWorkTypeID == nil)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

                Text("Due \(occurrence.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                if let treeID {
                    Text(lastFertilizedLabel(for: treeID))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Register") {
                if let treeID { presentRegister(for: treeID) }
            }
            .disabled(fertilizingWorkTypeID == nil || treeID == nil)

            Button("Open") {
                if let treeID { appState.showTreeFromMap(treeID: treeID) }
            }
            .buttonStyle(.borderless)
            .disabled(treeID == nil)
        }
        .padding(.vertical, FaloSpacing.xSmall)
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

                Text(record.performedAt.formatted(date: .abbreviated, time: .omitted))
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
                    presentRegister(for: tree.id, fertilizerTypeID: pendingFertilizerTypeID)
                } label: {
                    HStack(spacing: FaloSpacing.medium) {
                        TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(TreePresentation.title(for: tree))
                            Text(lastFertilizedLabel(for: tree.id))
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

    private func lastFertilizedLabel(for treeID: UUID) -> String {
        if let date = workService.lastCompletedFertilizingDate(for: treeID) {
            return "Last fertilized \(date.formatted(date: .abbreviated, time: .omitted))"
        }
        return "No fertilizing Work yet"
    }

    private func beginRegister(withFertilizerTypeID fertilizerTypeID: UUID) {
        pendingFertilizerTypeID = fertilizerTypeID
        isPickTreePresented = true
    }

    private func presentRegister(for treeID: UUID, fertilizerTypeID: UUID? = nil) {
        registerTreeID = treeID
        registerFertilizerTypeID = fertilizerTypeID ?? pendingFertilizerTypeID
        pendingFertilizerTypeID = nil
        isRegisterPresented = true
    }

    private func adviceRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Text(value)
                .font(FaloTypography.body)
                .textSelection(.enabled)
        }
        .padding(.bottom, FaloSpacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }

    private func lookupPicker<Value: Hashable, Content: View>(
        _ title: String,
        selection: Binding<Value>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Picker(title, selection: selection) {
                content()
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, FaloSpacing.xSmall)
    }
}

private struct CareFertilizerCatalogRow: Identifiable, Hashable {
    var id: UUID { fertilizer.id }
    let fertilizer: FertilizerType
    let stockItems: [InventoryStockItem]

    var inStock: Bool { !stockItems.isEmpty }

    var subtitle: String {
        var parts = [fertilizer.classificationSummary]
        let npk = fertilizer.npk.trimmingCharacters(in: .whitespacesAndNewlines)
        if !npk.isEmpty {
            parts.append(npk)
        }
        if let first = stockItems.first {
            parts.append(first.quantitySummary)
        }
        return parts.joined(separator: " · ")
    }
}
