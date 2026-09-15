//
//  SoilStockSplitView.swift
//  Bonsai World
//
//  Stock list + detail inside the Soil workspace (Pots pattern, two-column inner split).
//

import SwiftUI

enum SoilStockListFilter: String, CaseIterable, Identifiable {
    case all
    case lowStock

    var id: Self { self }

    var title: String {
        switch self {
        case .all: "All"
        case .lowStock: "Low stock"
        }
    }
}

struct SoilStockSplitView: View {
    @Environment(AppState.self) private var appState
    @Environment(SoilStockService.self) private var soilStock
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageService.self) private var imageService

    @State private var search = ""
    @State private var filter: SoilStockListFilter = .all
    @State private var grainFilter: SoilGrainSizeBand?

    private var rows: [SoilStockItem] {
        soilStock.items
            .filter { filter == .all || $0.isLowStock }
            .filter { grainFilter == nil || $0.grainSize.band == grainFilter }
            .filter { item in
                let needle = search.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !needle.isEmpty else { return true }
                let name = referenceData.soilComponent(id: item.componentID)?.name ?? ""
                return name.localizedCaseInsensitiveContains(needle)
                    || item.brand.localizedCaseInsensitiveContains(needle)
                    || item.supplier.localizedCaseInsensitiveContains(needle)
            }
            .sorted {
                let lhs = referenceData.soilComponent(id: $0.componentID)?.name ?? ""
                let rhs = referenceData.soilComponent(id: $1.componentID)?.name ?? ""
                return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
            }
    }

    var body: some View {
        @Bindable var appState = appState

        HSplitView {
            VStack(spacing: 0) {
                header
                Divider()
                List(rows, selection: $appState.selectedSoilStockID) { item in
                    SoilStockListRow(
                        item: item,
                        name: referenceData.soilComponent(id: item.componentID)?.name ?? "Unknown material",
                        imageService: imageService
                    )
                    .tag(item.id)
                }
                .faloScrollSurface()
                .overlay {
                    if soilStock.items.isEmpty {
                        ContentUnavailableView(
                            "Soil Stock is empty.",
                            systemImage: "square.stack.3d.up",
                            description: Text("Add the substrate materials you currently keep.")
                        )
                    } else if rows.isEmpty {
                        ContentUnavailableView(
                            "No Matching Stock",
                            systemImage: "line.3.horizontal.decrease.circle",
                            description: Text("Try a different search or filter.")
                        )
                    }
                }
            }
            .frame(minWidth: 280, idealWidth: 380)

            SoilStockDetailView()
                .frame(minWidth: 360)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            HStack {
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                Picker("Status", selection: $filter) {
                    ForEach(SoilStockListFilter.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 120)
            }
            Picker("Grain size", selection: $grainFilter) {
                Text("Any grain size").tag(Optional<SoilGrainSizeBand>.none)
                ForEach(SoilGrainSizeBand.allCases) { band in
                    Text(band.title).tag(Optional(band))
                }
            }
            .labelsHidden()
        }
        .padding(FaloSpacing.medium)
    }
}

private struct SoilStockListRow: View {
    let item: SoilStockItem
    let name: String
    let imageService: ImageService

    var body: some View {
        HStack(spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: item.listImageID,
                imageService: imageService,
                placeholderSystemImage: "square.stack.3d.up.fill"
            )

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name)
                        .font(FaloCardTypography.fieldValue)
                    Spacer()
                    Text(item.stockStatusTitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Status \(item.stockStatusTitle)")
                }
                Text("\(item.grainSize.displayTitle) · \(SoilVolumeFormat.bags(item.bagCount)) bags · \(SoilVolumeFormat.liters(item.estimatedVolumeLiters)) estimated")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if item.isLowStock {
                    Text("Low stock · min \(SoilVolumeFormat.liters(item.minimumStockLiters))")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}
