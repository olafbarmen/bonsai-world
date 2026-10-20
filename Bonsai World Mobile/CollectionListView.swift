//
//  CollectionListView.swift
//  Bonsai World
//
//  Collections — same sections as Mac:
//  My Collections (open) → Smart Collections (collapsed) → Former Trees (collapsed).
//

import SwiftUI

struct CollectionListView: View {
    @Environment(DemoLibrary.self) private var library

    var onCreatedCollection: ((UUID) -> Void)? = nil

    @State private var isShowingNewCollection = false
    @State private var pendingCreatedCollectionID: UUID?
    @State private var isSmartExpanded = false
    @State private var isFormerExpanded = false

    private var manualCollections: [Collection] {
        library.collections
            .filter(\.isManual)
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private var smartCollections: [Collection] {
        library.collections
            .filter { collection in
                collection.isSmart
                    && SystemSmartCollections.lifecycleOutcome(for: collection.id) == nil
            }
            .sorted { lhs, rhs in
                let left = SystemSmartCollections.sortIndex(for: lhs.id) ?? Int.max
                let right = SystemSmartCollections.sortIndex(for: rhs.id) ?? Int.max
                if left != right { return left < right }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    private var formerTreeCollections: [Collection] {
        library.collections
            .filter { collection in
                collection.isSmart
                    && SystemSmartCollections.lifecycleOutcome(for: collection.id) != nil
            }
            .sorted { lhs, rhs in
                let left = SystemSmartCollections.sortIndex(for: lhs.id) ?? Int.max
                let right = SystemSmartCollections.sortIndex(for: rhs.id) ?? Int.max
                if left != right { return left < right }
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    private var hasAnyCollections: Bool {
        !manualCollections.isEmpty || !smartCollections.isEmpty || !formerTreeCollections.isEmpty
    }

    var body: some View {
        Group {
            if !hasAnyCollections {
                ContentUnavailableView {
                    Label("No Collections yet", systemImage: "square.stack.3d.up")
                } description: {
                    Text("Add a collection to group trees.")
                } actions: {
                    Button("New Collection") {
                        isShowingNewCollection = true
                    }
                    .accessibilityLabel("New Collection")
                }
            } else {
                collectionList
            }
        }
        .navigationTitle("Collections")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Collection") {
                    isShowingNewCollection = true
                }
                .accessibilityLabel("New Collection")
            }
        }
        .sheet(isPresented: $isShowingNewCollection, onDismiss: {
            if let id = pendingCreatedCollectionID {
                pendingCreatedCollectionID = nil
                onCreatedCollection?(id)
            }
        }) {
            NewCollectionView { id in
                pendingCreatedCollectionID = id
            }
        }
    }

    private var collectionList: some View {
        List {
            if !manualCollections.isEmpty {
                Section {
                    sectionTitle("My Collections")
                    ForEach(manualCollections) { collection in
                        collectionLink(collection)
                    }
                }
            }

            if !smartCollections.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $isSmartExpanded) {
                        ForEach(smartCollections) { collection in
                            collectionLink(collection)
                        }
                    } label: {
                        sectionTitle("Smart Collections")
                    }
                }
            }

            if !formerTreeCollections.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $isFormerExpanded) {
                        ForEach(formerTreeCollections) { collection in
                            collectionLink(collection)
                        }
                    } label: {
                        sectionTitle("Former Trees")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(FaloTypography.body)
            .fontWeight(.semibold)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .textCase(.none)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(BonsaiWorldColors.surface)
    }

    private func collectionLink(_ collection: Collection) -> some View {
        NavigationLink(value: MobileRoute.collection(collection.id)) {
            collectionRow(collection)
        }
        .listRowBackground(BonsaiWorldColors.surface)
    }

    private func collectionRow(_ collection: Collection) -> some View {
        let count = library.trees(in: collection).count
        let description = collection.description.trimmingCharacters(in: .whitespacesAndNewlines)
        return HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: collection.icon ?? "square.stack.3d.up")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 22, height: 22, alignment: .center)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(collection.name)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                if !description.isEmpty {
                    Text(description)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(2)
                }
                Text(count == 1 ? "1 Tree" : "\(count) Trees")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        CollectionListView()
    }
    .environment(DemoLibrary.preview)
}
