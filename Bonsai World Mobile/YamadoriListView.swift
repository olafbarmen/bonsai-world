//
//  YamadoriListView.swift
//  Bonsai World
//
//  Field Yamadori — trips, Yamadori Trees, Former Findings.
//

import SwiftUI

struct YamadoriListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedFind: ((UUID) -> Void)? = nil

    @State private var isShowingNew = false
    @State private var pendingCreatedFindID: UUID?

    private var trips: [Yamadori] { library.orderedYamadoriTrips }
    private var nurseryTrees: [Tree] { library.yamadoriNurseryTrees }
    private var transferredTrees: [Tree] { library.transferredYamadoriTrees }
    private var formerFindings: [YamadoriFind] { library.formerYamadoriFindings }

    private var isEmpty: Bool {
        trips.isEmpty && nurseryTrees.isEmpty && transferredTrees.isEmpty && formerFindings.isEmpty
    }

    var body: some View {
        Group {
            if isEmpty {
                ContentUnavailableView {
                    Label("No Yamadori yet", systemImage: "leaf.circle")
                } description: {
                    Text("Start a trip to track finds in the field.")
                } actions: {
                    Button("New Yamadori") {
                        isShowingNew = true
                    }
                    .accessibilityLabel("New Yamadori")
                }
            } else {
                catalogList
            }
        }
        .navigationTitle("Yamadori")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Yamadori") {
                    isShowingNew = true
                }
                .accessibilityLabel("New Yamadori")
            }
        }
        .sheet(isPresented: $isShowingNew, onDismiss: {
            if let id = pendingCreatedFindID {
                pendingCreatedFindID = nil
                onCreatedFind?(id)
            }
        }) {
            NewYamadoriView { findID in
                pendingCreatedFindID = findID
            }
        }
    }

    private var catalogList: some View {
        List {
            Section("Trips") {
                if trips.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                    Button("New Yamadori") {
                        isShowingNew = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("New Yamadori")
                } else {
                    ForEach(trips) { trip in
                        NavigationLink(value: MobileRoute.yamadoriTrip(trip.id)) {
                            tripRow(trip)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            Section("Yamadori Trees") {
                if nurseryTrees.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                } else {
                    ForEach(nurseryTrees) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            nurseryRow(tree)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            if !transferredTrees.isEmpty {
                Section("Transferred Trees") {
                    ForEach(transferredTrees) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            nurseryRow(tree)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            if !formerFindings.isEmpty {
                Section("Former Findings") {
                    ForEach(formerFindings) { find in
                        NavigationLink(value: MobileRoute.yamadoriFind(find.id)) {
                            formerFindRow(find)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func tripRow(_ trip: Yamadori) -> some View {
        let finds = library.finds(forYamadoriID: trip.id)
        return VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(trip.displayName.isEmpty ? "Yamadori" : trip.displayName)
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            Text(findsSummary(finds))
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func nurseryRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            MobileTreeImage(tree: tree, style: .list)
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(MobileTreePresentation.title(for: tree))
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text(MobileTreePresentation.bonsaiNameLine(for: tree))
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                if let mixName = soilMixName(for: tree) {
                    Text(mixName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func soilMixName(for tree: Tree) -> String? {
        guard let mixID = tree.soilMixID,
              let name = library.soilMix(id: mixID)?.name.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty
        else { return nil }
        return name
    }

    private func formerFindRow(_ find: YamadoriFind) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text("\(find.yamadoriCode) · \(find.status.title)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            Spacer(minLength: 0)
            if find.hasCoordinates {
                Image(systemName: "mappin.circle.fill")
                    .font(.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Has map pin")
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }

    private func findsSummary(_ finds: [YamadoriFind]) -> String {
        let pinned = finds.filter(\.hasCoordinates).count
        let total = finds.count
        let base: String
        switch total {
        case 0: base = "No Finds"
        case 1: base = finds[0].yamadoriCode
        default: base = "\(total) Finds"
        }
        guard total > 0 else { return base }
        if pinned == 0 { return base }
        if pinned == total { return "\(base) · \(pinned == 1 ? "1 pinned" : "\(pinned) pinned")" }
        return "\(base) · \(pinned) of \(total) pinned"
    }
}

#Preview {
    NavigationStack {
        YamadoriListView()
    }
    .environment(DemoLibrary.preview)
}
