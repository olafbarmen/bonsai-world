//
//  LocationDetailView.swift
//  Bonsai World
//
//  Location Map Inspector — right-hand panel for the Garden Map.
//  Selecting a Location reveals a full Detail page (Header, Environment + Weather
//  risks, Notes, Trees Here). This is the single place Location content is shown —
//  the Locations list itself never duplicates this content (see LocationsListView).
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
    @Environment(WeatherService.self) private var weatherService

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
        let gardenName = profile.garden(id: location.gardenID)?.name

        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                DetailHeader(
                    title: location.name,
                    subtitle: typeName == FaloDisplayValue.empty ? nil : typeName,
                    onEdit: { appState.presentEditLocation(id: location.id) }
                )

                detailsCard(
                    gardenName: gardenName,
                    treeCount: trees.count,
                    lastWork: lastWork,
                    nextWork: nextWork
                )
                environmentCard(location)
                notesCard(location)
                treesHereCard(trees)
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }

    // MARK: - Details card

    @ViewBuilder
    private func detailsCard(
        gardenName: String?,
        treeCount: Int,
        lastWork: WorkRecord?,
        nextWork: WorkRecord?
    ) -> some View {
        DetailCard(title: "Details") {
            DetailLabeledRow(label: "Garden", value: gardenName ?? "")
            DetailLabeledRow(label: "Trees", value: treeCount == 1 ? "1 Tree" : "\(treeCount) Trees")
            DetailLabeledRow(label: "Last Work", value: workSummary(lastWork), emptyDisplay: "None")
            DetailLabeledRow(label: "Next Scheduled Work", value: workSummary(nextWork), emptyDisplay: "None")
        }
    }

    private func workSummary(_ record: WorkRecord?) -> String {
        guard let record else { return "" }
        let typeName = workService.workType(id: record.workTypeID)?.name ?? "Work"
        let date = record.performedAt.formatted(date: .abbreviated, time: .omitted)
        return "\(typeName) · \(date)"
    }

    // MARK: - Environment card (Phase 2 risks + full profile)

    @ViewBuilder
    private func environmentCard(_ location: LocationReference) -> some View {
        let risks = locationRiskBullets(location)
        let environment = location.environment

        DetailCard(title: "Environment") {
            if !risks.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(risks, id: \.self) { risk in
                        Label(risk, systemImage: "exclamationmark.triangle.fill")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.orange)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, FaloSpacing.xSmall)

                Divider()
                    .padding(.bottom, FaloSpacing.xSmall)
            }

            DetailLabeledRow(
                label: "Setting",
                value: environment.setting?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Sun Exposure",
                value: sunExposureSummary(environment),
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Shade Level",
                value: environment.shadeLevel?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Wind Exposure",
                value: environment.windExposure?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Rain Exposure",
                value: environment.rainExposure?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Humidity",
                value: environment.humidity?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Air Flow",
                value: environment.airFlow?.title ?? "",
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Watering Methods",
                value: wateringMethodsSummary(environment),
                emptyDisplay: "Not set"
            )
            DetailLabeledRow(
                label: "Winter Protection",
                value: environment.winterProtection?.title ?? "",
                emptyDisplay: "Not set"
            )
        }
    }

    private func sunExposureSummary(_ environment: LocationEnvironmentProfile) -> String {
        var parts: [String] = []
        if environment.morningSun { parts.append("Morning") }
        if environment.middaySun { parts.append("Midday") }
        if environment.afternoonSun { parts.append("Afternoon") }
        if environment.eveningSun { parts.append("Evening") }
        return parts.joined(separator: ", ")
    }

    /// A Location may combine several methods (e.g. drip + sprinkler, used manually
    /// when home and automatically while traveling) — show them all, sorted for stability.
    private func wateringMethodsSummary(_ environment: LocationEnvironmentProfile) -> String {
        environment.wateringMethods
            .sorted { $0.title < $1.title }
            .map(\.title)
            .joined(separator: ", ")
    }

    /// Weather is fetched for `profile.defaultGarden` only today, so risk bullets are
    /// only meaningful for Locations belonging to that Garden (see WeatherRiskAssessment
    /// .locationRisks doc comment; multi-Garden weather is a follow-up beyond Phase 4).
    private func locationRiskBullets(_ location: LocationReference) -> [String] {
        guard location.gardenID == profile.defaultGarden?.id,
              let snapshot = weatherService.snapshot
        else { return [] }
        return WeatherRiskAssessment.locationRisks(environment: location.environment, snapshot: snapshot)
    }

    // MARK: - Notes card

    @ViewBuilder
    private func notesCard(_ location: LocationReference) -> some View {
        DetailCard(title: "Notes") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                multilineField(label: "Description", text: location.locationDescription)
                multilineField(label: "Notes", text: location.notes)
            }
        }
    }

    @ViewBuilder
    private func multilineField(label: String, text: String) -> some View {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Text(trimmed.isEmpty ? "Not set" : trimmed)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(trimmed.isEmpty ? .secondary : .primary)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Trees Here card

    @ViewBuilder
    private func treesHereCard(_ trees: [Tree]) -> some View {
        DetailCard(title: trees.count == 1 ? "1 Tree Here" : "\(trees.count) Trees Here") {
            if trees.isEmpty {
                ContentUnavailableView(
                    "No Trees",
                    systemImage: "leaf",
                    description: Text("No Trees are assigned to this Location.")
                )
                .frame(minHeight: 140)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(trees.enumerated()), id: \.element.id) { index, tree in
                        Button {
                            openTree(tree.id)
                        } label: {
                            LocationInspectorTreeRow(tree: tree)
                        }
                        .buttonStyle(.plain)
                        // Future: multi-select, batch Work, drag between Locations.
                        if index < trees.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }

    private func openTree(_ treeID: UUID) {
        appState.showTreeFromMap(treeID: treeID)
    }
}

// MARK: - Tree row (reuses Tree model — no duplicated data)

private struct LocationInspectorTreeRow: View {
    let tree: Tree

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            TreeListThumbnail(imageID: tree.listImageID)

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
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens Tree Details")
    }

    private var bonsaiName: String {
        let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? TreePresentation.title(for: tree) : name
    }

    private var speciesLine: String {
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? FaloDisplayValue.empty : botanical
    }
}

#Preview {
    let state = AppState()
    let store = ReferencePreviewData()
    let preview = PreviewData()
    let reference = ReferenceDataService(previewData: store)
    let profile = UserProfileStore()
    state.selectedSection = .locationsPlaces
    state.selectedLocationID = store.locations.first?.id
    return LocationDetailView()
        .environment(state)
        .environment(profile)
        .environment(reference)
        .environment(TreeService.preview(previewData: preview))
        .environment(WorkService(referenceData: reference))
        .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
        .environment(WeatherService(profile: profile))
}
