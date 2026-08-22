//
//  CollectionTokenPicker.swift
//  Bonsai World
//
//  Compact token-based Collection multi-select for New Tree and similar forms.
//  Selected collections appear as removable tokens; + Add opens a searchable popup.
//

import SwiftUI

struct CollectionTokenPicker: View {
    let collections: [Collection]
    @Binding var selectedIDs: Set<UUID>
    var onCreateNew: (() -> Void)? = nil

    @State private var isPickerPresented = false
    @State private var searchText = ""

    private var selectedCollections: [Collection] {
        collections
            .filter { selectedIDs.contains($0.id) }
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    private var availableCollections: [Collection] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return collections
            .filter { !selectedIDs.contains($0.id) }
            .filter {
                query.isEmpty
                    || $0.name.localizedCaseInsensitiveContains(query)
                    || $0.description.localizedCaseInsensitiveContains(query)
            }
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    var body: some View {
        if collections.isEmpty {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                Text("No collections yet")
                    .foregroundStyle(.secondary)
                if onCreateNew != nil {
                    createCollectionButton
                }
            }
        } else {
            CollectionTokenFlowLayout(spacing: FaloSpacing.small) {
                ForEach(selectedCollections) { collection in
                    collectionToken(collection)
                }

                addCollectionButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func collectionToken(_ collection: Collection) -> some View {
        HStack(spacing: FaloSpacing.xSmall) {
            Text(collection.name)
                .font(FaloTypography.body)
                .lineLimit(1)

            Button {
                selectedIDs.remove(collection.id)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Remove \(collection.name)")
            .accessibilityLabel("Remove \(collection.name)")
        }
        .padding(.horizontal, FaloSpacing.small)
        .padding(.vertical, FaloSpacing.xSmall)
        .background {
            Capsule(style: .continuous)
                .fill(Color.primary.opacity(0.08))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var addCollectionButton: some View {
        Button {
            searchText = ""
            isPickerPresented = true
        } label: {
            Label("Add Collection", systemImage: "plus")
                .font(FaloTypography.body)
                .labelStyle(.titleAndIcon)
                .padding(.horizontal, FaloSpacing.small)
                .padding(.vertical, FaloSpacing.xSmall)
        }
        .buttonStyle(.borderless)
        .popover(isPresented: $isPickerPresented, arrowEdge: .bottom) {
            collectionPickerPopover
        }
        .help("Add a collection")
        .disabled(collections.allSatisfy { selectedIDs.contains($0.id) } && onCreateNew == nil)
    }

    private var createCollectionButton: some View {
        Button {
            onCreateNew?()
        } label: {
            Label("+ New Collection…", systemImage: "plus")
                .font(FaloTypography.body)
        }
        .buttonStyle(.borderless)
    }

    private var collectionPickerPopover: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Search Collections", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(FaloSpacing.medium)

            Divider()

            if availableCollections.isEmpty {
                VStack(spacing: FaloSpacing.medium) {
                    Text(emptyPickerMessage)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    if onCreateNew != nil {
                        Button {
                            isPickerPresented = false
                            onCreateNew?()
                        } label: {
                            Label("New Collection…", systemImage: "plus")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(FaloSpacing.large)
            } else {
                List {
                    ForEach(availableCollections) { collection in
                        Button {
                            selectedIDs.insert(collection.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(collection.name)
                                    .foregroundStyle(.primary)
                                if !collection.description.isEmpty {
                                    Text(collection.description)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    if onCreateNew != nil {
                        Section {
                            Button {
                                isPickerPresented = false
                                onCreateNew?()
                            } label: {
                                Label("+ New Collection…", systemImage: "plus")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: .infinity)
            }
        }
        .frame(width: 280, height: 320)
    }

    private var emptyPickerMessage: String {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            return "No collections match “\(query)”."
        }
        if selectedIDs.count >= collections.count, onCreateNew == nil {
            return "All collections are already selected."
        }
        if collections.isEmpty, onCreateNew != nil {
            return "Create a collection with New Collection… below."
        }
        return "No collections available."
    }
}

// MARK: - Flow layout

/// Wraps token chips horizontally without growing the parent Form height beyond content.
private struct CollectionTokenFlowLayout: Layout {
    var spacing: CGFloat = FaloSpacing.small

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth {
                y += rowHeight + spacing
                totalHeight = y
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            totalWidth = max(totalWidth, x - spacing)
            totalHeight = y + rowHeight
        }

        return CGSize(
            width: proposal.width ?? totalWidth,
            height: totalHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
