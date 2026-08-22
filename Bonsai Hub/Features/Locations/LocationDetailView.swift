//
//  LocationDetailView.swift
//  Bonsai World
//
//  Location Map Inspector — right-hand panel for the Garden Map.
//  Selecting a Location reveals contents. Selecting a Tree opens Tree Details.
//  Reuses Tree models (Single Source of Truth). No duplicated Tree data.
//
//  Prepared for: multi-selection, batch Work / watering / fertilizing,
//  drag-and-drop between Locations — not implemented yet.
//

import SwiftUI
import AppKit

struct LocationDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(UserProfileStore.self) private var profile
    @Environment(TreeService.self) private var treeService
    @Environment(WorkService.self) private var workService
    @Environment(ImageService.self) private var imageService

    private var location: LocationReference? {
        guard let id = appState.selectedLocationID else { return nil }
        return referenceData.location(id: id)
    }

    var body: some View {
        Group {
            if let location {
                locationInspector(location)
            } else {
                ContentUnavailableView(
                    "Select a Location",
                    systemImage: "mappin.and.ellipse",
                    description: Text("Click a Location on the Garden Map to inspect its Trees.")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
        .navigationTitle(location?.name ?? "Location Inspector")
    }

    @ViewBuilder
    private func locationInspector(_ location: LocationReference) -> some View {
        let trees = treeService.trees(at: location.id)
        let typeName = FaloDisplayValue.text(
            referenceData.locationType(id: location.locationTypeID)?.name
        )
        let lastWork = workService.lastWork(involving: trees.map(\.id))
        let nextWork = workService.nextScheduledWork(involving: trees.map(\.id))

        VStack(alignment: .leading, spacing: 0) {
            inspectorHeader(
                location: location,
                typeName: typeName,
                treeCount: trees.count,
                lastWork: lastWork,
                nextWork: nextWork
            )

            Divider()

            if trees.isEmpty {
                ContentUnavailableView(
                    "No Trees",
                    systemImage: "leaf",
                    description: Text("No Trees are assigned to this Location.")
                )
            } else {
                List(trees, id: \.id) { tree in
                    Button {
                        openTree(tree.id)
                    } label: {
                        LocationInspectorTreeRow(tree: tree)
                    }
                    .buttonStyle(.plain)
                    // Future: multi-select, batch Work, drag between Locations.
                }
                .listStyle(.inset)
                .faloScrollSurface()
            }
        }
    }

    @ViewBuilder
    private func inspectorHeader(
        location: LocationReference,
        typeName: String,
        treeCount: Int,
        lastWork: WorkRecord?,
        nextWork: WorkRecord?
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(location.name)
                        .font(FaloTypography.headline)
                    Text(typeName == FaloDisplayValue.empty ? "Location" : typeName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Button("Edit") {
                    appState.presentEditLocation(id: location.id)
                }
                .buttonStyle(.borderless)
            }

            Grid(alignment: .leading, horizontalSpacing: FaloSpacing.xLarge, verticalSpacing: FaloSpacing.small) {
                GridRow {
                    Text("Trees")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(treeCount == 1 ? "1 Tree" : "\(treeCount) Trees")
                        .font(FaloTypography.body)
                }
                GridRow {
                    Text("Last Work")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(workSummary(lastWork))
                        .font(FaloTypography.body)
                        .foregroundStyle(lastWork == nil ? .secondary : .primary)
                }
                GridRow {
                    Text("Next Scheduled Work")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(workSummary(nextWork))
                        .font(FaloTypography.body)
                        .foregroundStyle(nextWork == nil ? .secondary : .primary)
                }
            }

            if let gardenName = profile.garden(id: location.gardenID)?.name {
                Text(gardenName)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(FaloSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.windowBackground)
    }

    private func workSummary(_ record: WorkRecord?) -> String {
        guard let record else { return "None" }
        let typeName = workService.workType(id: record.workTypeID)?.name ?? "Work"
        let date = record.performedAt.formatted(date: .abbreviated, time: .omitted)
        return "\(typeName) · \(date)"
    }

    private func openTree(_ treeID: UUID) {
        appState.showTreeFromMap(treeID: treeID)
    }
}

// MARK: - Tree row (reuses Tree model — no duplicated data)

private struct LocationInspectorTreeRow: View {
    let tree: Tree

    @Environment(ImageService.self) private var imageService
    @State private var thumbnail: NSImage?

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            thumbnailView

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(bonsaiName)
                    .font(FaloTypography.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if let nickname = TreePresentation.nicknameIfPresent(for: tree) {
                    Text(nickname)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Text(speciesLine)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Label(tree.healthStatus.title, systemImage: tree.healthStatus.systemImage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
                    .labelStyle(.titleAndIcon)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .contentShape(Rectangle())
        .task(id: tree.primaryImageID) {
            await loadThumbnail()
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens Tree Details")
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let thumbnail {
            Image(nsImage: thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        } else {
            ThumbnailPlaceholder(systemImage: "leaf.fill", size: 48)
        }
    }

    private var bonsaiName: String {
        let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? TreePresentation.title(for: tree) : name
    }

    private var speciesLine: String {
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? FaloDisplayValue.empty : botanical
    }

    private func loadThumbnail() async {
        guard let imageID = tree.primaryImageID else {
            thumbnail = nil
            return
        }
        do {
            let data = try await imageService.loadOriginalData(for: imageID)
            thumbnail = NSImage(data: data)
        } catch {
            thumbnail = nil
        }
    }
}

#Preview {
    let state = AppState()
    let store = ReferencePreviewData()
    let preview = PreviewData()
    let reference = ReferenceDataService(previewData: store)
    state.selectedSection = .locationsPlaces
    state.selectedLocationID = store.locations.first?.id
    return LocationDetailView()
        .environment(state)
        .environment(UserProfileStore())
        .environment(reference)
        .environment(TreeService.preview(previewData: preview))
        .environment(WorkService(referenceData: reference))
        .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
}
