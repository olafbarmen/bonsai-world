//
//  CollectionsList.swift
//  Bonsai World
//
//  Sectioned Collections master list:
//  My Collections (open) → Smart Collections (collapsed) → Former Trees (collapsed).
//  Single list column; no type browser pane.
//

import SwiftUI

struct CollectionsList: View {
    let smartCollections: [Collection]
    let formerTreeCollections: [Collection]
    let manualCollections: [Collection]
    @Binding var selection: UUID?
    var treeCount: (Collection) -> Int

    @State private var isSmartExpanded = false
    @State private var isFormerExpanded = false

    var body: some View {
        List(selection: $selection) {
            if !manualCollections.isEmpty {
                Section {
                    collectionsSectionTitle("My Collections")
                    ForEach(manualCollections) { collection in
                        collectionRow(collection)
                    }
                }
            }

            if !smartCollections.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $isSmartExpanded) {
                        ForEach(smartCollections) { collection in
                            collectionRow(collection)
                        }
                    } label: {
                        collectionsSectionTitle("Smart Collections")
                    }
                }
            }

            if !formerTreeCollections.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $isFormerExpanded) {
                        ForEach(formerTreeCollections) { collection in
                            collectionRow(collection)
                        }
                    } label: {
                        collectionsSectionTitle("Former Trees")
                    }
                }
            }
        }
        .faloScrollSurface()
        .onAppear {
            expandSectionIfNeeded(for: selection)
        }
        .onChange(of: selection) { _, newValue in
            expandSectionIfNeeded(for: newValue)
        }
    }

    private func expandSectionIfNeeded(for id: UUID?) {
        guard let id else { return }
        if smartCollections.contains(where: { $0.id == id }) {
            isSmartExpanded = true
        }
        if formerTreeCollections.contains(where: { $0.id == id }) {
            isFormerExpanded = true
        }
    }

    private func collectionsSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(FaloTypography.body)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .textCase(.none)
    }

    @ViewBuilder
    private func collectionRow(_ collection: Collection) -> some View {
        CollectionListRow(
            name: collection.name,
            description: collection.description,
            treeCount: treeCount(collection),
            systemImage: collection.icon ?? "square.stack.3d.up"
        )
        .tag(collection.id)
    }
}

struct CollectionListRow: View {
    let name: String
    let description: String
    let treeCount: Int
    var systemImage: String = "square.stack.3d.up"

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 22, height: 22, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(name)
                    .font(FaloTypography.body)
                    .foregroundStyle(.primary)

                if !description.isEmpty {
                    Text(description)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(treeCount == 1 ? "1 Tree" : "\(treeCount) Trees")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let previewData = PreviewData()
    let smart = previewData.collections.filter { collection in
        collection.isSmart
            && SystemSmartCollections.lifecycleOutcome(for: collection.id) == nil
    }
    let former = previewData.collections.filter { collection in
        collection.isSmart
            && SystemSmartCollections.lifecycleOutcome(for: collection.id) != nil
    }
    let manual = previewData.collections.filter(\.isManual)
    return CollectionsList(
        smartCollections: smart,
        formerTreeCollections: former,
        manualCollections: manual,
        selection: .constant(manual.first?.id),
        treeCount: { previewData.trees(in: $0.id).count }
    )
    .frame(width: 280, height: 420)
}
