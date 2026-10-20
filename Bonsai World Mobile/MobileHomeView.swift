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
        ZStack {
            BonsaiWorldColors.canvas
            GeometryReader { geo in
                let top = geo.frame(in: .global).minY
                FaloBonsaiWash(width: 250)
                    .position(x: geo.size.width - 133, y: 210 - top)
            }
            .allowsHitTesting(false)
            List {
                greetingSection
                attentionSection
                inProgressSection
                tasksSection
                worldsSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
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
            .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
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
                    .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
            } else {
                ForEach(attention) { tree in
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
                    .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
                    .accessibilityLabel("\(MobileTreePresentation.title(for: tree)), \(tree.healthStatus.title)")
                    .accessibilityHint("Opens tree profile")
                }
            }
        }
    }

    @ViewBuilder
    private var inProgressSection: some View {
        let items = Array(library.shapingInProgressItems.prefix(6))
        if !items.isEmpty {
            Section("In Progress") {
                ForEach(items) { item in
                    Button {
                        openMobileTree(item.treeID)
                    } label: {
                        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                            Text(item.area.title)
                                .font(FaloTypography.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                            Text(inProgressDetail(item))
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                        }
                        .padding(.vertical, FaloSpacing.xSmall)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
                    .accessibilityLabel("\(item.area.title), \(inProgressDetail(item))")
                    .accessibilityHint("Opens tree profile")
                }
            }
        }
    }

    private func inProgressDetail(_ item: DemoLibrary.ShapingInProgressItem) -> String {
        if item.nextAction.isEmpty { return item.treeTitle }
        if item.treeTitle.isEmpty { return item.nextAction }
        return "\(item.treeTitle) · \(item.nextAction)"
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
            .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
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
            worldLink(.propagation, title: "Propagation", caption: "Cuttings · Air Layers")
            worldLink(.soil, title: "Soil", caption: countCaption(library.orderedSoilMixes.count, "Mix", "Mixes"))
            worldLink(
                .inventory(lowOnly: !library.lowInventoryStock.isEmpty),
                title: "Inventory",
                caption: inventoryCaption
            )
            worldLink(.pots, title: "Pots", caption: countCaption(library.orderedPots.count, "Pot", "Pots"))
            worldLink(.images, title: "Images", caption: imagesCaption)
            worldLink(.work, title: "Work", caption: workCaption)
        }

        Section("Knowledge") {
            knowledgeLink(.knowledgeShelf(.quickGuides), title: "Quick Guides")
            knowledgeLink(.handbook, title: "Bonsai Handbook")
            knowledgeLink(.careCalendar, title: "Care Calendar")
            knowledgeLink(.handbookChapter(.potGuidelines), title: "Pots & Containers")
            knowledgeLink(.speciesLibrary, title: "Species Library")
            knowledgeLink(.handbookChapter(.soilGuides), title: "Soil & Substrate")
            knowledgeLink(.fertilizerGuides, title: "Fertilizer Guides")
            knowledgeLink(.seedStratification, title: "Seed Stratification")
            knowledgeLink(.knowledgeShelf(.videos), title: "Video Tutorials")
            knowledgeLink(.knowledgeShelf(.courses), title: "Courses")
            knowledgeLink(.knowledgeShelf(.faq), title: "FAQ")
            knowledgeLink(.knowledgeShelf(.externalLinks), title: "External Links")
        }

        Section("Places") {
            worldLink(.gardens, title: "Gardens", caption: countCaption(library.orderedGardens.count, "Garden", "Gardens"))
            worldLink(.locations, title: "Locations", caption: countCaption(library.orderedLocations.count, "Location", "Locations"))
            worldLink(
                .collections,
                title: "Collections",
                caption: countCaption(library.collections.filter(\.isManual).count, "Collection", "Collections")
            )
        }
    }

    private func knowledgeLink(_ route: MobileRoute, title: String) -> some View {
        NavigationLink(value: route) {
            HStack {
                Text(title)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        }
        .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
        .accessibilityLabel(title)
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
        .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
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

    private var imagesCaption: String {
        countCaption(library.orderedImageAssets.count, "Photo", "Photos")
    }

    private var workCaption: String {
        let count = library.workRecords.count
        if count == 0 { return "Empty" }
        return count == 1 ? "1 Record" : "\(count) Records"
    }

    private func countCaption(_ count: Int, _ singular: String, _ plural: String) -> String {
        if count == 0 { return "Empty" }
        if count == 1 { return "1 \(singular)" }
        return "\(count) \(plural)"
    }
}

/// Falo mark, faded into the canvas at the top trailing corner.
private struct FaloBonsaiWash: View {
    var width: CGFloat

    var body: some View {
        Image("FaloBonsaiWash")
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .blendMode(.multiply)
            .opacity(0.88)
            .mask(
                RadialGradient(
                    colors: [.black, .black.opacity(0.45), .clear],
                    center: .center,
                    startRadius: width * 0.18,
                    endRadius: width * 0.52
                )
            )
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#Preview {
    NavigationStack {
        MobileHomeView()
    }
    .environment(DemoLibrary.preview)
}
