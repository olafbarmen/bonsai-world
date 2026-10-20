//
//  PotListView.swift
//  Bonsai World
//
//  Field Inventory → Pots — Mac PotListView titles and status filter.
//

import SwiftUI

private enum MobilePotListFilter: String, CaseIterable, Identifiable {
    case active
    case available
    case inUse
    case sold
    case broken
    case retired
    case all

    var id: Self { self }

    var title: String {
        switch self {
        case .active: "Active"
        case .available: "Available"
        case .inUse: "In Use"
        case .sold: "Sold"
        case .broken: "Broken"
        case .retired: "Retired"
        case .all: "All"
        }
    }

    func matches(_ status: PotStatus) -> Bool {
        switch self {
        case .active: status == .available || status == .inUse
        case .available: status == .available
        case .inUse: status == .inUse
        case .sold: status == .sold
        case .broken: status == .broken
        case .retired: status == .retired
        case .all: true
        }
    }
}

struct PotListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedPot: ((UUID) -> Void)? = nil

    @State private var filter: MobilePotListFilter = .active
    @State private var isShowingNew = false
    @State private var pendingCreatedID: UUID?
    @State private var potPendingDelete: UUID?
    @State private var confirmDelete = false

    private var displayedPots: [Pot] {
        library.orderedPots.filter { filter.matches($0.status) }
    }

    var body: some View {
        Group {
            if library.orderedPots.isEmpty {
                ContentUnavailableView {
                    Label("No Pots", systemImage: "shippingbox")
                } description: {
                    Text("Add an inventory pot.")
                } actions: {
                    Button("New Pot") { isShowingNew = true }
                        .accessibilityLabel("New Pot")
                }
            } else {
                potList
            }
        }
        .navigationTitle("Pots")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Pot") { isShowingNew = true }
                    .accessibilityLabel("New Pot")
            }
        }
        .sheet(isPresented: $isShowingNew, onDismiss: {
            if let id = pendingCreatedID {
                pendingCreatedID = nil
                onCreatedPot?(id)
            }
        }) {
            NewPotView { id in
                pendingCreatedID = id
            }
        }
        .confirmationDialog(
            "Delete this pot?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = potPendingDelete {
                    library.deletePot(id: id)
                }
                potPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                potPendingDelete = nil
            }
        }
    }

    private var potList: some View {
        List {
            Section {
                Picker("Filter", selection: $filter) {
                    ForEach(MobilePotListFilter.allCases) { value in
                        Text(value.title).tag(value)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityLabel("Filter")
            }

            if displayedPots.isEmpty {
                Section {
                    Text("No pots match this filter.")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                }
            } else {
                Section {
                    ForEach(displayedPots) { pot in
                        NavigationLink(value: MobileRoute.pot(pot.id)) {
                            potRow(pot)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", role: .destructive) {
                                potPendingDelete = pot.id
                                confirmDelete = true
                            }
                            .accessibilityLabel("Delete Pot")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func potRow(_ pot: Pot) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(library.displayName(for: pot))
                .font(FaloTypography.body)
                .fontWeight(.semibold)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
            HStack(spacing: FaloSpacing.small) {
                Text(pot.status.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                if let treeID = pot.linkedTreeID,
                   let tree = library.tree(id: treeID)
                {
                    Text(MobileTreePresentation.title(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        PotListView()
    }
    .environment(DemoLibrary.preview)
}
