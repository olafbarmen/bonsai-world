//
//  MobileHomeView.swift
//  Bonsai World
//
//  Home dash — greeting, attention, tasks, and doorways into field worlds.
//  Not an editing surface: no filters, no New Tree.
//

import SwiftUI

struct MobileHomeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.appendMobileRoute) private var appendMobileRoute
    @Environment(\.openMobileTree) private var openMobileTree

    var body: some View {
        List {
            greetingSection
            attentionSection
            tasksSection
            worldsSection
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Bonsai World")
        .navigationBarTitleDisplayMode(.large)
    }

    private var greetingSection: some View {
        Section {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(greetingLine)
                    .font(FaloTypography.greeting)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(greetingSubtitle)
                    .font(FaloTypography.pageSubtitle)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            .padding(.vertical, FaloSpacing.small)
            .listRowBackground(BonsaiWorldColors.surface)
            .accessibilityElement(children: .combine)
        }
    }

    private var attentionSection: some View {
        let attention = library.treesNeedingAttention
        return Section("Attention") {
            if attention.isEmpty {
                Text("Nothing needs attention.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .listRowBackground(BonsaiWorldColors.surface)
            } else {
                ForEach(attention.prefix(5)) { tree in
                    Button {
                        openMobileTree(tree.id)
                    } label: {
                        HStack(spacing: FaloSpacing.medium) {
                            MobileTreeImage(tree: tree, style: .list)
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                Text(MobileTreePresentation.title(for: tree))
                                    .font(FaloTypography.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                                MobileHealthBadge(status: tree.healthStatus)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(BonsaiWorldColors.textTertiary)
                                .accessibilityHidden(true)
                        }
                        .padding(.vertical, FaloSpacing.xSmall)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("\(MobileTreePresentation.title(for: tree)), \(tree.healthStatus.title)")
                    .accessibilityHint("Opens tree profile")
                }
                if !attention.isEmpty {
                    NavigationLink(value: MobileRoute.myTreesAttention) {
                        Text(attention.count > 5 ? "See all \(attention.count)" : "Open in My Trees")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.accent)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel(attention.count > 5 ? "See all \(attention.count)" : "Open in My Trees")
                    .accessibilityHint("Opens My Trees filtered to trees that need attention")
                }
            }
        }
    }

    private var tasksSection: some View {
        let overdue = library.pendingTasks(due: .overdue).count
        let today = library.pendingTasks(due: .today).count
        return Section("Tasks") {
            Button {
                appendMobileRoute(.tasks)
            } label: {
                HStack {
                    Text("Tasks")
                        .font(FaloTypography.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    Spacer()
                    Text(tasksSummary(overdue: overdue, today: today))
                        .font(FaloTypography.body)
                        .foregroundStyle(
                            overdue > 0
                                ? BonsaiWorldColors.statusAttention
                                : BonsaiWorldColors.textSecondary
                        )
                        .monospacedDigit()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .listRowBackground(BonsaiWorldColors.surface)
            .accessibilityLabel(tasksAccessibilityLabel(overdue: overdue, today: today))
            .accessibilityHint("Open the Tasks tab")
        }
    }

    @ViewBuilder
    private var worldsSection: some View {
        Section("Field") {
            worldLink(.myTrees, title: "My Trees", caption: treeCountCaption)
            worldLink(.yamadori, title: "Yamadori", caption: countCaption(library.orderedYamadoriTrips.count, "Trip", "Trips"))
            worldLink(.seeds, title: "Seeds", caption: seedsCaption)
            worldLink(.soil, title: "Soil", caption: countCaption(library.orderedSoilMixes.count, "Mix", "Mixes"))
            worldLink(
                .inventory(lowOnly: !library.lowInventoryStock.isEmpty),
                title: "Inventory",
                caption: inventoryCaption
            )
        }

        Section("Places") {
            worldLink(.gardens, title: "Gardens", caption: countCaption(library.orderedGardens.count, "Garden", "Gardens"))
            worldLink(.locations, title: "Locations", caption: countCaption(library.orderedLocations.count, "Location", "Locations"))
            worldLink(.collections, title: "Collections", caption: countCaption(library.collections.count, "Collection", "Collections"))
        }
    }

    private func worldLink(_ route: MobileRoute, title: String, caption: String) -> some View {
        NavigationLink(value: route) {
            HStack {
                Text(title)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Spacer(minLength: FaloSpacing.small)
                Text(caption)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .monospacedDigit()
            }
        }
        .listRowBackground(BonsaiWorldColors.surface)
        .accessibilityLabel(inventoryAccessibilityLabel(title: title, caption: caption))
    }

    private func inventoryAccessibilityLabel(title: String, caption: String) -> String {
        if title == "Inventory", caption.hasSuffix("low") || caption == "1 low" {
            return "\(title), \(caption) stock"
        }
        return "\(title), \(caption)"
    }

    private var hasGrowerName: Bool {
        !library.growerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var greetingLine: String {
        let trimmed = library.growerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let first = trimmed.split(separator: " ").first.map(String.init)
        if let first, !first.isEmpty {
            return "\(greetingWord), \(first)"
        }
        return greetingWord
    }

    private var greetingSubtitle: String {
        if hasGrowerName {
            return "Here is what is happening in your collection today."
        }
        return "Set your name in Settings."
    }

    private var greetingWord: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }

    private func tasksSummary(overdue: Int, today: Int) -> String {
        if overdue == 0 && today == 0 { return "0" }
        if overdue == 0 { return today == 1 ? "1 today" : "\(today) today" }
        if today == 0 { return overdue == 1 ? "1 overdue" : "\(overdue) overdue" }
        return "\(overdue) overdue · \(today) today"
    }

    private func tasksAccessibilityLabel(overdue: Int, today: Int) -> String {
        let overduePart = overdue == 1 ? "1 overdue" : "\(overdue) overdue"
        let todayPart = today == 1 ? "1 today" : "\(today) today"
        return "Tasks, \(overduePart), \(todayPart)"
    }

    private var treeCountCaption: String {
        let count = library.myTrees.count
        if count == 0 { return "Empty" }
        return count == 1 ? "1 Tree" : "\(count) Trees"
    }

    private var seedsCaption: String {
        let total = library.orderedSeedBatches.count
        let active = library.activeSeedBatchCount
        if total == 0 { return "Empty" }
        if active == total { return countCaption(total, "Batch", "Batches") }
        return "\(active) active"
    }

    private var inventoryCaption: String {
        let total = library.orderedInventoryStock.count
        let low = library.lowInventoryStock.count
        if total == 0 { return "Empty" }
        if low > 0 { return low == 1 ? "1 low" : "\(low) low" }
        return countCaption(total, "Item", "Items")
    }

    private func countCaption(_ count: Int, _ singular: String, _ plural: String) -> String {
        if count == 0 { return "Empty" }
        if count == 1 { return "1 \(singular)" }
        return "\(count) \(plural)"
    }
}

#Preview {
    NavigationStack {
        MobileHomeView()
    }
    .environment(DemoLibrary.preview)
}
