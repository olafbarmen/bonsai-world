//
//  PotListView.swift
//  Bonsai World
//
//  Inventory → Pots browser. Mirrors Tree list conventions (thumbnail + key
//  attributes, status filter) at a smaller scale appropriate for a first pass.
//

import SwiftUI

/// Status filter for the Pot list. Available is the default — Sold / Broken /
/// Retired stay out of the normal view but remain reachable here or in History.
enum PotListFilter: String, CaseIterable, Identifiable {
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
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(PotService.self) private var potService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService

    @State private var filter: PotListFilter = .active

    private var pots: [Pot] {
        potService.pots
            .filter { filter.matches($0.status) }
            .sorted {
                let lhsName = displayName(for: $0)
                let rhsName = displayName(for: $1)
                return lhsName.localizedCaseInsensitiveCompare(rhsName) == .orderedAscending
            }
    }

    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 0) {
            header
            Divider()
            List(pots, selection: $appState.selectedPotID) { pot in
                PotListRow(
                    pot: pot,
                    displayName: displayName(for: pot),
                    potType: pot.potTypeID.flatMap { referenceData.potType(id: $0) },
                    brand: pot.brandID.flatMap { referenceData.potBrand(id: $0) },
                    maker: pot.makerID.flatMap { referenceData.potMaker(id: $0) },
                    linkedTreeName: pot.linkedTreeID.flatMap { treeService.getTree(id: $0) }.map(TreePresentation.registryLabel(for:)),
                    sizeText: sizeSummary(for: pot),
                    imageService: imageService
                )
                .tag(pot.id)
            }
            .faloScrollSurface()
            .overlay {
                if pots.isEmpty {
                    ContentUnavailableView(
                        "No Pots",
                        systemImage: "shippingbox",
                        description: Text("Use Context Tools → New Pot to add one.")
                    )
                }
            }
        }
        .bonsaiWorkspaceNavigationTitle("Pots")
        .navigationSplitViewColumnWidth(min: 320, ideal: 420, max: 640)
        .onAppear { reconcileSelection() }
        .onChange(of: filter) { _, _ in reconcileSelection() }
        .onChange(of: potService.pots.map(\.id)) { _, _ in reconcileSelection() }
        .onChange(of: potService.pots.map(\.status)) { _, _ in reconcileSelection() }
    }

    private func reconcileSelection() {
        if let selected = appState.selectedPotID,
           pots.contains(where: { $0.id == selected }) {
            return
        }
        appState.selectedPotID = nil
    }

    private var header: some View {
        Picker("Filter", selection: $filter) {
            ForEach(PotListFilter.allCases) { filter in
                Text(filter.title).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .padding(FaloSpacing.medium)
    }

    private func displayName(for pot: Pot) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if let potTypeID = pot.potTypeID, let type = referenceData.potType(id: potTypeID) {
            return type.name
        }
        return "Untitled Pot"
    }

    private func sizeSummary(for pot: Pot) -> String {
        let system = appSettings.measurementSystem
        let segments: [(String, Int?, MeasurementDimension)] = [
            ("L", pot.lengthMillimetres, .potLength),
            ("W", pot.widthMillimetres, .potWidth),
            ("H", pot.heightMillimetres, .potHeight),
            ("D", pot.diameterMillimetres, .potDiameter)
        ]
        let formatted = segments.compactMap { label, millimetres, dimension -> String? in
            guard millimetres != nil else { return nil }
            let value = MeasurementService.string(millimetres: millimetres, dimension: dimension, system: system, empty: "")
            guard !value.isEmpty else { return nil }
            return "\(label) \(value)"
        }
        return formatted.joined(separator: " · ")
    }
}

private struct PotListRow: View {
    let pot: Pot
    let displayName: String
    let potType: PotType?
    let brand: PotBrand?
    let maker: PotMaker?
    let linkedTreeName: String?
    let sizeText: String
    let imageService: ImageService

    var body: some View {
        HStack(spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: pot.listImageID,
                imageService: imageService,
                placeholderSystemImage: "shippingbox.fill"
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(FaloTypography.body)
                HStack(spacing: FaloSpacing.xSmall) {
                    if let potType {
                        Text(potType.name)
                    }
                    if let brand {
                        Text("·")
                        Text(brand.name)
                    }
                    if let maker {
                        Text("·")
                        Text(maker.name)
                    }
                }
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                if !sizeText.isEmpty {
                    Text(sizeText)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 2) {
                Text(pot.status.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if let linkedTreeName {
                    Text(linkedTreeName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}
