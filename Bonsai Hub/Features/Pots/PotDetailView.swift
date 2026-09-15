//
//  PotDetailView.swift
//  Bonsai World
//
//  Pot Detail — Identity, Physical, Dating, Purchase, Current Use, Media, History, Notes.
//  Edit Mode covers Identity / Physical / Dating / Purchase / Notes only (manual Save, not
//  autosave-per-field — a deliberately lighter editing model than Tree Detail for
//  this first pass). Status, Current Use, and Media act immediately regardless of
//  Edit Mode, since they go through PotService lifecycle calls that keep Tree ↔ Pot
//  sync and History correct.
//

import SwiftUI

struct PotDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(PotService.self) private var potService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService

    @State private var draft: PotDetailDraft?
    @State private var assignTreeTarget: AssignTreeSheetTarget?
    @State private var statusChangeKind: PotStatusChangeKind?
    @State private var errorMessage: String?
    @State private var selectedPhotoID: UUID?

    private var pot: Pot? {
        guard let id = appState.selectedPotID else { return nil }
        return potService.getPot(id: id)
    }

    private var isEditing: Bool { appState.potDetailInteractionMode.isEditing }

    var body: some View {
        Group {
            if let pot {
                content(for: pot)
            } else {
                ContentUnavailableView(
                    "Select a Pot",
                    systemImage: "shippingbox",
                    description: Text("Choose a pot from the list.")
                )
            }
        }
        .onChange(of: appState.selectedPotID) { _, _ in
            draft = nil
            selectedPhotoID = nil
        }
        .onChange(of: draft?.brandID) { _, newBrandID in
            guard var draft else { return }
            if let makerID = draft.makerID,
               let maker = referenceData.potMaker(id: makerID),
               let makerBrandID = maker.brandID,
               makerBrandID != newBrandID {
                draft.makerID = nil
                self.draft = draft
            }
        }
        .onChange(of: appState.pendingPotQuickAction) { _, request in
            guard let request else { return }
            handle(request.command)
            appState.clearPendingPotQuickAction()
        }
        .sheet(item: $assignTreeTarget) { target in
            PotAssignTreeSheet(potID: target.id)
                .environment(treeService)
                .environment(potService)
        }
        .sheet(item: $statusChangeKind) { kind in
            PotStatusChangeSheet(kind: kind) { date, detail, price, notes in
                guard let pot else { return }
                performStatusChange(kind: kind, potID: pot.id, date: date, detail: detail, price: price, notes: notes)
            }
        }
        .alert("Could Not Update Pot", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func content(for pot: Pot) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                identitySection(pot)
                physicalSection(pot)
                datingSection(pot)
                purchaseSection(pot)
                currentUseSection(pot)
                mediaSection(pot)
                historySection(pot)
                notesSection(pot)
            }
            .padding(FaloSpacing.medium)
        }
        .faloScrollSurface()
        .navigationTitle(displayName(for: pot))
    }

    // MARK: - Identity

    private func identitySection(_ pot: Pot) -> some View {
        DetailCard(title: "Identity") {
            PotIdentityPhotosSection(
                imageIDs: pot.imageIDs,
                primaryImageID: pot.primaryImageID,
                selectedImageID: $selectedPhotoID,
                onAddImage: { addImage(to: pot) },
                onSetPrimary: { id in try? potService.setPrimaryImage(potID: pot.id, imageID: id) },
                onRemove: { id in
                    try? potService.removeImage(potID: pot.id, imageID: id)
                    if selectedPhotoID == id {
                        selectedPhotoID = potService.getPot(id: pot.id)?.listImageID
                    }
                }
            )

            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Name", text: binding.name)
                DetailOptionPickerRow(
                    label: "Pot Type",
                    selection: binding.potTypeID,
                    placeholder: "Select Pot Type",
                    options: DetailPickerOption.map(referenceData.potTypes)
                )
                DetailLabeledRow(
                    label: "Country / Origin",
                    value: originText(forBrandID: binding.brandID.wrappedValue).isEmpty
                        ? (binding.makerID.wrappedValue.flatMap { referenceData.potMaker(id: $0)?.country } ?? "")
                        : originText(forBrandID: binding.brandID.wrappedValue)
                )
                DetailOptionPickerRow(
                    label: "Brand / Kiln",
                    selection: binding.brandID,
                    placeholder: "Unknown / Not Set",
                    options: DetailPickerOption.map(referenceData.potBrands)
                )
                DetailOptionPickerRow(
                    label: "Maker / Potter",
                    selection: binding.makerID,
                    placeholder: "Unknown / Not Set",
                    options: DetailPickerOption.map(makersForDraftSelection)
                )
                DetailLabeledRow(
                    label: "Maker Type",
                    value: makerTypeTitle(forMakerID: binding.makerID.wrappedValue)
                )
                DetailEditableTextRow(label: "Generation / Period", text: binding.generationPeriod)
                    .help("Optional. Leave empty to use the Maker’s default generation / period.")
            } else {
                DetailLabeledRow(label: "Name", value: displayName(for: pot))
                DetailLabeledRow(
                    label: "Pot Type",
                    value: pot.potTypeID.flatMap { referenceData.potType(id: $0)?.name } ?? ""
                )
                DetailLabeledRow(
                    label: "Country / Origin",
                    value: countryOriginDisplay(for: pot)
                )
                DetailLabeledRow(
                    label: "Brand / Kiln",
                    value: pot.brandID.flatMap { referenceData.potBrand(id: $0)?.name } ?? ""
                )
                DetailLabeledRow(
                    label: "Maker / Potter",
                    value: pot.makerID.flatMap { referenceData.potMaker(id: $0)?.name } ?? ""
                )
                DetailLabeledRow(
                    label: "Maker Type",
                    value: makerTypeTitle(forMakerID: pot.makerID)
                )
                DetailLabeledRow(
                    label: "Generation / Period",
                    value: generationPeriodDisplay(for: pot)
                )
            }
        }
    }

    private var makersForDraftSelection: [PotMaker] {
        referenceData.potMakersSelectable(forBrandID: draft?.brandID)
    }

    private func originText(forBrandID brandID: UUID?) -> String {
        guard let brand = brandID.flatMap({ referenceData.potBrand(id: $0) }) else { return "" }
        return [brand.country, brand.originText].filter { !$0.isEmpty }.joined(separator: " · ")
    }

    private func countryOriginDisplay(for pot: Pot) -> String {
        let fromBrand = originText(forBrandID: pot.brandID)
        if !fromBrand.isEmpty { return fromBrand }
        return pot.makerID.flatMap { referenceData.potMaker(id: $0)?.country } ?? ""
    }

    private func makerTypeTitle(forMakerID makerID: UUID?) -> String {
        guard let makerID,
              let maker = referenceData.potMaker(id: makerID),
              maker.makerType != .unknown
        else { return "" }
        return maker.makerType.title
    }

    /// Pot-specific generation / period wins; otherwise the Maker’s default.
    private func generationPeriodDisplay(for pot: Pot) -> String {
        let trimmed = pot.generationPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        return pot.makerID.flatMap { referenceData.potMaker(id: $0)?.generation } ?? ""
    }

    // MARK: - Physical

    private func physicalSection(_ pot: Pot) -> some View {
        DetailCard(title: "Physical") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Material", text: binding.material)
                DetailEditableTextRow(label: "Glaze", text: binding.glaze)
                DetailEditableTextRow(label: "Shape", text: binding.shape)
                dimensionEditRow(title: "Length", dimension: .potLength, value: binding.lengthMillimetres)
                dimensionEditRow(title: "Width", dimension: .potWidth, value: binding.widthMillimetres)
                dimensionEditRow(title: "Height", dimension: .potHeight, value: binding.heightMillimetres)
                dimensionEditRow(title: "Diameter", dimension: .potDiameter, value: binding.diameterMillimetres)
                DetailEditableTextRow(label: "Condition", text: binding.condition)
            } else {
                DetailLabeledRow(label: "Material", value: pot.material)
                DetailLabeledRow(label: "Glaze", value: pot.glaze)
                DetailLabeledRow(label: "Shape", value: pot.shape)
                DetailLabeledRow(label: "Dimensions", value: dimensionsSummary(pot))
                DetailLabeledRow(label: "Condition", value: pot.condition)
            }
        }
    }

    // MARK: - Dating

    private func datingSection(_ pot: Pot) -> some View {
        DetailCard(title: "Dating") {
            if isEditing, let binding = draftBinding {
                yearEditRow(label: "Made Year", value: binding.madeYear)
                yearEditRow(label: "Estimated From", value: binding.estimatedFromYear)
                yearEditRow(label: "Estimated To", value: binding.estimatedToYear)
                datingConfidencePicker(binding: binding.datingConfidence)
                DetailEditableTextRow(label: "Dating Notes", text: binding.datingNotes)
            } else {
                DetailLabeledRow(label: "Made Year", value: pot.madeYear.map(String.init) ?? "")
                DetailLabeledRow(label: "Estimated Production Period", value: estimatedPeriodDisplay(pot))
                DetailLabeledRow(label: "Dating Confidence", value: pot.datingConfidence.title)
                DetailLabeledRow(label: "Dating Notes", value: pot.datingNotes)
            }
        }
    }

    private func estimatedPeriodDisplay(_ pot: Pot) -> String {
        switch (pot.estimatedFromYear, pot.estimatedToYear) {
        case let (from?, to?):
            return from == to ? String(from) : "\(from)–\(to)"
        case let (from?, nil):
            return "From \(from)"
        case let (nil, to?):
            return "To \(to)"
        case (nil, nil):
            return ""
        }
    }

    @ViewBuilder
    private func datingConfidencePicker(binding: Binding<PotDatingConfidence>) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Dating Confidence")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Picker("Dating Confidence", selection: binding) {
                ForEach(PotDatingConfidence.allCases, id: \.self) { confidence in
                    Text(confidence.title).tag(confidence)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .font(FaloCardTypography.fieldValue)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private func yearEditRow(label: String, value: Binding<Int?>) -> some View {
        DetailEditableTextRow(
            label: label,
            text: Binding(
                get: { value.wrappedValue.map(String.init) ?? "" },
                set: { newValue in
                    let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty {
                        value.wrappedValue = nil
                    } else if let year = Int(trimmed) {
                        value.wrappedValue = year
                    }
                }
            )
        )
    }

    private func dimensionsSummary(_ pot: Pot) -> String {
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

    @ViewBuilder
    private func dimensionEditRow(title: String, dimension: MeasurementDimension, value: Binding<Int?>) -> some View {
        let system = appSettings.measurementSystem
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width
        DetailEditableTextRow(
            label: "\(title) (\(unit))",
            text: Binding(
                get: { MeasurementService.editableNumericString(millimetres: value.wrappedValue, role: role, system: system) },
                set: { value.wrappedValue = MeasurementService.millimetres(fromDisplayText: $0, role: role, system: system) }
            )
        )
    }

    // MARK: - Purchase

    private func purchaseSection(_ pot: Pot) -> some View {
        DetailCard(title: "Purchase") {
            if isEditing, let binding = draftBinding {
                DatePickerOptionalRow(label: "Purchase Date", date: binding.purchaseDate)
                DetailEditableTextRow(
                    label: "Purchase Price (\(appSettings.currency.code))",
                    text: Binding(
                        get: { CurrencyFormatting.editableNumericString(binding.purchasePrice.wrappedValue) },
                        set: { binding.purchasePrice.wrappedValue = CurrencyFormatting.parseAmount($0) }
                    )
                )
                DetailEditableTextRow(label: "Seller", text: binding.purchaseSellerName)
                DetailEditableTextRow(label: "Purchase Notes", text: binding.purchaseNotes)
            } else {
                DetailLabeledRow(label: "Purchase Date", value: pot.purchaseDate.map(Self.dateFormatter.string(from:)) ?? "")
                DetailLabeledRow(
                    label: "Purchase Price",
                    value: CurrencyFormatting.string(pot.purchasePrice, currency: appSettings.currency, empty: "")
                )
                DetailLabeledRow(label: "Seller", value: pot.purchaseSellerName)
                DetailLabeledRow(label: "Purchase Notes", value: pot.purchaseNotes)
            }
        }
    }

    // MARK: - Current Use

    private func currentUseSection(_ pot: Pot) -> some View {
        DetailCard(title: "Current Use") {
            DetailLabeledRow(label: "Status", value: pot.status.title)

            if let treeID = pot.linkedTreeID, let tree = treeService.getTree(id: treeID) {
                DetailLabeledRow(label: "Linked Tree", value: TreePresentation.registryName(for: tree))
                if let subtitle = TreePresentation.registrySubtitle(for: tree) {
                    DetailLabeledRow(label: "Species", value: subtitle)
                }
                Button("Unlink from Tree") {
                    try? potService.unassignCurrentPot(fromTreeID: treeID)
                }
            } else {
                DetailLabeledRow(label: "Linked Tree", value: "")
            }

            HStack(spacing: FaloSpacing.small) {
                switch pot.status {
                case .available:
                    Button("Assign to Tree") { assignTreeTarget = AssignTreeSheetTarget(id: pot.id) }
                    Button("Mark Sold") { statusChangeKind = .sold }
                    Button("Mark Broken") { statusChangeKind = .broken }
                    Button("Mark Retired") { statusChangeKind = .retired }
                case .inUse:
                    Button("Mark Sold") { statusChangeKind = .sold }
                    Button("Mark Broken") { statusChangeKind = .broken }
                    Button("Mark Retired") { statusChangeKind = .retired }
                case .sold, .broken, .retired:
                    Button("Return to Available") {
                        try? potService.returnToAvailable(potID: pot.id)
                    }
                }
            }
            .buttonStyle(.bordered)

            if pot.status == .sold {
                DetailLabeledRow(label: "Sale Date", value: pot.saleDate.map(Self.dateFormatter.string(from:)) ?? "")
                DetailLabeledRow(label: "Sale Price", value: CurrencyFormatting.string(pot.salePrice, currency: appSettings.currency, empty: ""))
                DetailLabeledRow(label: "Buyer", value: pot.saleBuyerName)
            }
            if pot.status == .broken {
                DetailLabeledRow(label: "Broken Date", value: pot.brokenDate.map(Self.dateFormatter.string(from:)) ?? "")
                DetailLabeledRow(label: "Reason", value: pot.brokenReason)
            }
            if pot.status == .retired {
                DetailLabeledRow(label: "Retired Date", value: pot.retiredDate.map(Self.dateFormatter.string(from:)) ?? "")
            }
        }
    }

    // MARK: - Media

    private func mediaSection(_ pot: Pot) -> some View {
        DetailCard(title: "Media") {
            PotImageStrip(
                title: "Actual Stamp Photos",
                imageIDs: pot.stampImageIDs,
                primaryImageID: nil,
                onAdd: { addStampImage(to: pot) },
                onSetPrimary: nil,
                onRemove: { id in try? potService.removeStampImage(potID: pot.id, imageID: id) }
            )

            if let brand = pot.brandID.flatMap({ referenceData.potBrand(id: $0) }), !brand.stampReferenceImageIDs.isEmpty {
                PotImageStrip(
                    title: "\(brand.name) — Known Stamps (Reference)",
                    imageIDs: brand.stampReferenceImageIDs,
                    primaryImageID: nil,
                    onAdd: nil,
                    onSetPrimary: nil,
                    onRemove: nil
                )
            }
            if let maker = pot.makerID.flatMap({ referenceData.potMaker(id: $0) }), !maker.stampReferenceImageIDs.isEmpty {
                PotImageStrip(
                    title: "\(maker.name) — Known Stamps (Reference)",
                    imageIDs: maker.stampReferenceImageIDs,
                    primaryImageID: nil,
                    onAdd: nil,
                    onSetPrimary: nil,
                    onRemove: nil
                )
            }
        }
    }

    private func addImage(to pot: Pot) {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            if pot.primaryImageID == nil {
                try? potService.setPrimaryImage(potID: pot.id, imageID: asset.id)
            } else {
                var updated = pot
                if !updated.imageIDs.contains(asset.id) {
                    updated.imageIDs.append(asset.id)
                }
                _ = try? potService.updatePot(updated)
            }
            selectedPhotoID = asset.id
        }
    }

    private func addStampImage(to pot: Pot) {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            try? potService.addStampImage(potID: pot.id, imageID: asset.id)
        }
    }

    // MARK: - History

    private func historySection(_ pot: Pot) -> some View {
        DetailCard(title: "History") {
            if pot.history.isEmpty {
                DetailLabeledRow(label: "History", value: "")
            } else {
                ForEach(pot.history.sorted { $0.date > $1.date }) { entry in
                    DetailLabeledRow(
                        label: Self.dateFormatter.string(from: entry.date),
                        value: entry.note.isEmpty ? entry.kind.title : "\(entry.kind.title) — \(entry.note)"
                    )
                }
            }
        }
    }

    // MARK: - Notes

    private func notesSection(_ pot: Pot) -> some View {
        DetailCard(title: "Notes") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Notes", text: binding.notes)
            } else {
                DetailLabeledRow(label: "Notes", value: pot.notes)
            }
        }
    }

    // MARK: - Edit Mode

    private var draftBinding: Binding<PotDetailDraft>? {
        guard draft != nil else { return nil }
        return Binding(
            get: { draft ?? .from(pot ?? Pot()) },
            set: { draft = $0 }
        )
    }

    private func beginEditing(_ pot: Pot) {
        draft = .from(pot)
        appState.potDetailInteractionMode = .editing
    }

    private func commitDraft(for pot: Pot) {
        guard let draft else {
            appState.potDetailInteractionMode = .viewing
            return
        }
        do {
            try potService.applyDetailDraft(id: pot.id, draft: draft)
            self.draft = nil
            appState.potDetailInteractionMode = .viewing
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func handle(_ command: PotQuickActionCommand) {
        guard let pot else { return }
        switch command {
        case .editPot:
            beginEditing(pot)
        case .addImage:
            addImage(to: pot)
        case .markSold:
            statusChangeKind = .sold
        case .markBroken:
            statusChangeKind = .broken
        case .markRetired:
            statusChangeKind = .retired
        case .returnToAvailable:
            try? potService.returnToAvailable(potID: pot.id)
        case .deletePot:
            try? potService.deletePot(id: pot.id)
            appState.selectedPotID = nil
        case .cancel:
            // "Finish" leaves Edit Mode. Unlike Tree (autosave-per-field), Pot Detail
            // holds unsaved changes in `draft` — commit them so Finish never discards.
            commitDraft(for: pot)
        }
    }

    private func performStatusChange(
        kind: PotStatusChangeKind,
        potID: UUID,
        date: Date,
        detail: String,
        price: Decimal?,
        notes: String
    ) {
        do {
            switch kind {
            case .sold:
                try potService.markSold(potID: potID, date: date, price: price, buyerName: detail, notes: notes)
            case .broken:
                try potService.markBroken(potID: potID, date: date, reason: detail, notes: notes)
            case .retired:
                try potService.markRetired(potID: potID, date: date, notes: notes)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func displayName(for pot: Pot) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if let potTypeID = pot.potTypeID, let type = referenceData.potType(id: potTypeID) {
            return type.name
        }
        return "Untitled Pot"
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

/// Optional-date row for Edit Mode (Purchase Date may be cleared).
private struct AssignTreeSheetTarget: Identifiable, Hashable {
    let id: UUID
}

private struct DatePickerOptionalRow: View {
    let label: String
    @Binding var date: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            HStack {
                Toggle(isOn: Binding(
                    get: { date != nil },
                    set: { date = $0 ? (date ?? .now) : nil }
                )) {
                    EmptyView()
                }
                .labelsHidden()
                .toggleStyle(.checkbox)

                if let unwrapped = date {
                    DatePicker(
                        label,
                        selection: Binding(get: { unwrapped }, set: { date = $0 }),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                }
            }
        }
    }
}
