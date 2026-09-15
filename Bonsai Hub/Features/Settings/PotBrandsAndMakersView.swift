//
//  PotBrandsAndMakersView.swift
//  Bonsai World
//
//  Settings → Pot Brands & Makers. User-managed reference data for the Pot Module.
//  Brand and Maker are edited here only — the New Pot sheet and Pot Detail can pick
//  them, never create them, so there is exactly one place manufacturer records
//  can be added and no way to end up with silent duplicates.
//
//  Makers may exist independently when no Brand/Kiln relationship is documented.
//

import SwiftUI

struct PotBrandsAndMakersView: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(PotService.self) private var potService

    @State private var isNewBrandPresented = false
    @State private var editingBrandID: UUID?
    @State private var editingMaker: (brandID: UUID?, makerID: UUID?)?
    @State private var brandPendingDeleteID: UUID?

    private var sortedBrands: [PotBrand] {
        _ = manager.revision
        return manager.allPotBrands()
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    private var independentMakers: [PotMaker] {
        _ = manager.revision
        return manager.independentPotMakers()
    }

    private var catalogIsEmpty: Bool {
        sortedBrands.isEmpty && independentMakers.isEmpty
    }

    var body: some View {
        List {
            ForEach(sortedBrands) { brand in
                Section {
                    brandRow(brand)
                    ForEach(manager.potMakers(forBrandID: brand.id)) { maker in
                        makerRow(maker)
                    }
                    Button {
                        editingMaker = (brand.id, nil)
                    } label: {
                        Label("Add Maker / Potter", systemImage: "plus")
                    }
                    .buttonStyle(.borderless)
                    .padding(.leading, FaloSpacing.large)
                } header: {
                    Text(brand.country.isEmpty ? brand.name : "\(brand.country) · \(brand.name)")
                }
            }

            Section {
                ForEach(independentMakers) { maker in
                    makerRow(maker)
                }
                Button {
                    editingMaker = (nil, nil)
                } label: {
                    Label("Add Independent Maker / Potter", systemImage: "plus")
                }
                .buttonStyle(.borderless)
            } header: {
                Text("Independent Makers / Potters")
            } footer: {
                Text("Makers without a documented Brand / Kiln relationship.")
                    .font(FaloTypography.caption)
            }
        }
        .faloScrollSurface()
        .bonsaiWorkspaceNavigationTitle("Pot Brands & Makers")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isNewBrandPresented = true
                } label: {
                    Label("New Brand / Kiln", systemImage: "plus")
                }
            }
        }
        .overlay {
            if catalogIsEmpty {
                ContentUnavailableView(
                    "No Pot Brands Yet",
                    systemImage: "seal",
                    description: Text("Add manufacturers, studios, and kilns — or independent makers when no Brand / Kiln is documented.")
                )
            }
        }
        .sheet(isPresented: $isNewBrandPresented) {
            PotBrandEditorSheet(draft: manager.blankPotBrandDraft())
        }
        .sheet(item: Binding(
            get: { editingBrandID.map { IdentifiableID(id: $0) } },
            set: { editingBrandID = $0?.id }
        )) { wrapped in
            if let draft = manager.potBrandDraft(for: wrapped.id) {
                PotBrandEditorSheet(draft: draft)
            }
        }
        .sheet(item: Binding(
            get: { editingMaker.map { PotMakerSheetTarget(brandID: $0.brandID, makerID: $0.makerID) } },
            set: { editingMaker = $0.map { ($0.brandID, $0.makerID) } }
        )) { target in
            let draft = target.makerID.flatMap(manager.potMakerDraft(for:))
                ?? manager.blankPotMakerDraft(brandID: target.brandID)
            PotMakerEditorSheet(draft: draft)
        }
        .confirmationDialog(
            "Delete this Brand?",
            isPresented: Binding(
                get: { brandPendingDeleteID != nil },
                set: { if !$0 { brandPendingDeleteID = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = brandPendingDeleteID {
                    manager.deletePotBrand(id)
                }
                brandPendingDeleteID = nil
            }
            Button("Cancel", role: .cancel) { brandPendingDeleteID = nil }
        } message: {
            Text("This removes the Brand record. Only available when no Pot or Maker references it.")
        }
    }

    private func brandRow(_ brand: PotBrand) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: FaloSpacing.xSmall) {
                    Text(brand.name)
                        .font(FaloTypography.headline)
                    Text(brand.kind.title)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    if brand.isSystemSeed {
                        Text("Seed")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !brand.isActive {
                        Text("Archived")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                if !brand.originText.isEmpty {
                    Text(brand.originText)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Menu {
                Button("Edit") { editingBrandID = brand.id }
                Button(brand.isActive ? "Archive" : "Reactivate") {
                    manager.setPotBrandActive(brand.id, isActive: !brand.isActive)
                }
                let inUse = manager.isPotBrandInUseByMakers(brand.id) || potService.isBrandInUse(brand.id)
                Button("Delete", role: .destructive) {
                    brandPendingDeleteID = brand.id
                }
                .disabled(inUse)
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .menuStyle(.borderlessButton)
            .frame(width: 24)
        }
    }

    private func makerRow(_ maker: PotMaker) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: FaloSpacing.xSmall) {
                    Text(maker.name)
                    if maker.makerType != .unknown {
                        Text("· \(maker.makerType.title)")
                            .foregroundStyle(.secondary)
                    }
                    if !maker.generation.isEmpty {
                        Text("· \(maker.generation)")
                            .foregroundStyle(.secondary)
                    }
                    if maker.isSystemSeed {
                        Text("· Seed")
                            .foregroundStyle(.secondary)
                    }
                    if !maker.isActive {
                        Text("Archived")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .font(FaloTypography.body)
                if maker.brandID == nil, !maker.country.isEmpty {
                    Text(maker.country)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Menu {
                Button("Edit") { editingMaker = (maker.brandID, maker.id) }
                Button(maker.isActive ? "Archive" : "Reactivate") {
                    manager.setPotMakerActive(maker.id, isActive: !maker.isActive)
                }
                Button("Delete", role: .destructive) {
                    manager.deletePotMaker(maker.id)
                }
                .disabled(potService.isMakerInUse(maker.id))
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .menuStyle(.borderlessButton)
            .frame(width: 24)
        }
        .padding(.leading, maker.brandID == nil ? 0 : FaloSpacing.large)
    }
}

private struct IdentifiableID: Identifiable {
    let id: UUID
}

private struct PotMakerSheetTarget: Identifiable {
    let brandID: UUID?
    let makerID: UUID?
    var id: String {
        "\(brandID?.uuidString ?? "independent")-\(makerID?.uuidString ?? "new")"
    }
}
