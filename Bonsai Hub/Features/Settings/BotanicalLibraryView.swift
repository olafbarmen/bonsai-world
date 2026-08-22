//
//  BotanicalLibraryView.swift
//  Bonsai World
//
//  Settings → Reference Data → Botanical Library
//  Three navigation columns: Genus → Species → Cultivar, plus a detail panel.
//  Add is context-aware; users never pick Type or parent relationships.
//

import SwiftUI

struct BotanicalLibraryView: View {
    @Environment(BotanicalService.self) private var botanical

    @State private var context = BotanicalLibraryContext()
    @State private var editorDraft: BotanicalDraft?
    @State private var pendingDelete: BotanicalSelection?

    private var genera: [Genus] {
        _ = botanical.revision
        return botanical.genera()
    }

    private var species: [Species] {
        _ = botanical.revision
        guard let genusID = context.selectedGenusID else { return [] }
        return botanical.species(forGenusID: genusID)
    }

    private var cultivars: [Cultivar] {
        _ = botanical.revision
        guard let speciesID = context.selectedSpeciesID else { return [] }
        return botanical.cultivars(forSpeciesID: speciesID)
    }

    private var focus: BotanicalSelection? {
        context.focus
    }

    private var addHelp: String {
        switch context.addKind {
        case .genus: "Add Genus"
        case .species: "Add Species to selected Genus"
        case .cultivar: "Add Cultivar to selected Species"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HSplitView {
                genusColumn
                    .frame(minWidth: 140, idealWidth: 160)

                speciesColumn
                    .frame(minWidth: 140, idealWidth: 160)

                cultivarColumn
                    .frame(minWidth: 140, idealWidth: 180)

                detailPanel
                    .frame(minWidth: 200, idealWidth: 240)
            }

            Divider()
            footerBar
        }
        .navigationTitle("Botanical Library")
        .sheet(item: $editorDraft) { draft in
            BotanicalEditorSheet(draft: draft)
        }
        .confirmationDialog(
            deleteDialogTitle,
            isPresented: Binding(
                get: { pendingDelete != nil },
                set: { if !$0 { pendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                performDelete()
            }
            Button("Cancel", role: .cancel) {
                pendingDelete = nil
            }
        } message: {
            Text(deleteDialogMessage)
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    presentAdd()
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .help(addHelp)

                Button {
                    presentEdit()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .disabled(focus == nil)
                .help("Edit selection")

                Button {
                    pendingDelete = focus
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(focus == nil)
                .help("Delete selection")
            }
        }
    }

    // MARK: - Columns

    private var genusColumn: some View {
        VStack(spacing: 0) {
            columnHeader("Genus")
            List(selection: genusSelection) {
                ForEach(genera) { genus in
                    BotanicalColumnRow(
                        title: genus.name,
                        isActive: genus.isActive
                    ) { isActive in
                        botanical.setActive(
                            BotanicalSelection(id: genus.id, kind: .genus),
                            isActive: isActive
                        )
                    }
                    .tag(Optional(genus.id))
                    .contextMenu { rowContextMenu(for: BotanicalSelection(id: genus.id, kind: .genus)) }
                }
            }
            .faloScrollSurface()
            .overlay {
                if genera.isEmpty {
                    ContentUnavailableView(
                        "No Genera",
                        systemImage: "leaf",
                        description: Text("Add a Genus to begin.")
                    )
                }
            }
        }
    }

    private var speciesColumn: some View {
        VStack(spacing: 0) {
            columnHeader("Species")
            List(selection: speciesSelection) {
                ForEach(species) { item in
                    BotanicalColumnRow(
                        title: botanical.speciesColumnLabel(item),
                        isActive: item.isActive
                    ) { isActive in
                        botanical.setActive(
                            BotanicalSelection(id: item.id, kind: .species),
                            isActive: isActive
                        )
                    }
                    .tag(Optional(item.id))
                    .contextMenu { rowContextMenu(for: BotanicalSelection(id: item.id, kind: .species)) }
                }
            }
            .faloScrollSurface()
            .overlay {
                if context.selectedGenusID == nil {
                    ContentUnavailableView(
                        "Select a Genus",
                        systemImage: "leaf",
                        description: Text("Species for the selected Genus appear here.")
                    )
                } else if species.isEmpty {
                    ContentUnavailableView(
                        "No Species",
                        systemImage: "leaf",
                        description: Text("Add a Species to this Genus.")
                    )
                }
            }
            .disabled(context.selectedGenusID == nil)
        }
    }

    private var cultivarColumn: some View {
        VStack(spacing: 0) {
            columnHeader("Cultivars")
            List(selection: cultivarSelection) {
                ForEach(cultivars) { item in
                    BotanicalColumnRow(
                        title: item.name,
                        isActive: item.isActive
                    ) { isActive in
                        botanical.setActive(
                            BotanicalSelection(id: item.id, kind: .cultivar),
                            isActive: isActive
                        )
                    }
                    .tag(Optional(item.id))
                    .contextMenu { rowContextMenu(for: BotanicalSelection(id: item.id, kind: .cultivar)) }
                }
            }
            .faloScrollSurface()
            .overlay {
                if context.selectedSpeciesID == nil {
                    ContentUnavailableView(
                        "Select a Species",
                        systemImage: "sparkles",
                        description: Text("Cultivars for the selected Species appear here.")
                    )
                } else if cultivars.isEmpty {
                    ContentUnavailableView(
                        "No Cultivars",
                        systemImage: "sparkles",
                        description: Text("Add a Cultivar to this Species.")
                    )
                }
            }
            .disabled(context.selectedSpeciesID == nil)
        }
    }

    private var detailPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            columnHeader("Detail")
            Group {
                if let cultivarID = context.selectedCultivarID,
                   let cultivar = botanical.cultivar(id: cultivarID) {
                    cultivarDetail(cultivar)
                } else if let speciesID = context.selectedSpeciesID,
                          let species = botanical.species(id: speciesID) {
                    speciesDetail(species)
                } else if let genusID = context.selectedGenusID,
                          let genus = botanical.genus(id: genusID) {
                    genusDetail(genus)
                } else {
                    ContentUnavailableView(
                        "Detail",
                        systemImage: "sidebar.right",
                        description: Text("Select a Genus, Species, or Cultivar.")
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .faloScrollSurface()
        }
    }

    // MARK: - Detail content

    private func genusDetail(_ genus: Genus) -> some View {
        Form {
            LabeledContent("Genus", value: genus.name)
            LabeledContent("Species", value: "\(species.count)")
            LabeledContent("Sort Order", value: "\(genus.sortOrder)")
            LabeledContent("Status", value: genus.isActive ? "Active" : "Inactive")
        }
        .formStyle(.grouped)
        .padding(.top, FaloSpacing.small)
    }

    private func speciesDetail(_ species: Species) -> some View {
        Form {
            LabeledContent("Genus") {
                Text(FaloDisplayValue.text(botanical.genusName(id: species.genusID)))
            }
            LabeledContent("Species", value: botanical.speciesColumnLabel(species))
            LabeledContent("Binomial", value: species.name)
            LabeledContent("Cultivars", value: "\(cultivars.count)")
            LabeledContent("Sort Order", value: "\(species.sortOrder)")
            LabeledContent("Status", value: species.isActive ? "Active" : "Inactive")
        }
        .formStyle(.grouped)
        .padding(.top, FaloSpacing.small)
    }

    private func cultivarDetail(_ cultivar: Cultivar) -> some View {
        let parentSpecies = botanical.species(id: cultivar.speciesID)
        let genusName = parentSpecies.flatMap { botanical.genusName(id: $0.genusID) }
        let speciesLabel = parentSpecies.map { botanical.speciesColumnLabel($0) }

        return Form {
            LabeledContent("Genus", value: FaloDisplayValue.text(genusName))
            LabeledContent("Species", value: FaloDisplayValue.text(speciesLabel))
            LabeledContent("Cultivar", value: cultivar.name)
            LabeledContent("Sort Order", value: "\(cultivar.sortOrder)")
            LabeledContent("Status", value: cultivar.isActive ? "Active" : "Inactive")
        }
        .formStyle(.grouped)
        .padding(.top, FaloSpacing.small)
    }

    // MARK: - Chrome

    private func columnHeader(_ title: String) -> some View {
        Text(title)
            .font(FaloTypography.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.vertical, FaloSpacing.small)
            .background(.bar)
    }

    private var footerBar: some View {
        HStack(spacing: FaloSpacing.small) {
            Button {
                presentAdd()
            } label: {
                Label(addButtonTitle, systemImage: "plus")
            }

            Button {
                presentEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .disabled(focus == nil)

            Button(role: .destructive) {
                pendingDelete = focus
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .disabled(focus == nil)

            Spacer()

            Text(statusSummary)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.borderless)
        .padding(.horizontal, FaloSpacing.medium)
        .padding(.vertical, FaloSpacing.small)
        .background(.bar)
    }

    private var addButtonTitle: String {
        "Add \(context.addKind.title)"
    }

    private var statusSummary: String {
        "\(genera.count) genera"
    }

    // MARK: - Selection bindings

    private var genusSelection: Binding<UUID?> {
        Binding(
            get: { context.selectedGenusID },
            set: { context.selectGenus($0) }
        )
    }

    private var speciesSelection: Binding<UUID?> {
        Binding(
            get: { context.selectedSpeciesID },
            set: { context.selectSpecies($0) }
        )
    }

    private var cultivarSelection: Binding<UUID?> {
        Binding(
            get: { context.selectedCultivarID },
            set: { context.selectCultivar($0) }
        )
    }

    // MARK: - Actions

    private func presentAdd() {
        editorDraft = botanical.draftForAdd(context: context)
    }

    private func presentEdit() {
        guard let focus else { return }
        editorDraft = botanical.draftForEdit(focus)
    }

    @ViewBuilder
    private func rowContextMenu(for selection: BotanicalSelection) -> some View {
        Button("Edit…") {
            applyFocus(selection)
            presentEdit()
        }
        Button("Delete…", role: .destructive) {
            pendingDelete = selection
        }
    }

    private func applyFocus(_ selection: BotanicalSelection) {
        switch selection.kind {
        case .genus:
            context.selectGenus(selection.id)
        case .species:
            if let species = botanical.species(id: selection.id) {
                context.selectedGenusID = species.genusID
                context.selectSpecies(selection.id)
            }
        case .cultivar:
            if let cultivar = botanical.cultivar(id: selection.id),
               let species = botanical.species(id: cultivar.speciesID) {
                context.selectedGenusID = species.genusID
                context.selectedSpeciesID = species.id
                context.selectCultivar(selection.id)
            }
        }
    }

    private func performDelete() {
        guard let pendingDelete else { return }
        botanical.delete(pendingDelete)

        switch pendingDelete.kind {
        case .genus:
            if context.selectedGenusID == pendingDelete.id {
                context.selectGenus(nil)
            }
        case .species:
            if context.selectedSpeciesID == pendingDelete.id {
                context.selectSpecies(nil)
            }
        case .cultivar:
            if context.selectedCultivarID == pendingDelete.id {
                context.selectCultivar(nil)
            }
        }
        self.pendingDelete = nil
    }

    private var deleteDialogTitle: String {
        guard let pending = pendingDelete else { return "Delete?" }
        return "Delete \(pending.kind.title)?"
    }

    private var deleteDialogMessage: String {
        guard let pending = pendingDelete else {
            return "This item will be removed from this session."
        }
        switch pending.kind {
        case .genus:
            let name = botanical.genusName(id: pending.id) ?? "This Genus"
            return "“\(name)” and all Species and Cultivars under it will be removed from this session."
        case .species:
            let name = botanical.species(id: pending.id).map { botanical.speciesColumnLabel($0) } ?? "This Species"
            return "“\(name)” and all Cultivars under it will be removed from this session."
        case .cultivar:
            let name = botanical.cultivar(id: pending.id)?.name ?? "This Cultivar"
            return "“\(name)” will be removed from this session. This cannot be undone."
        }
    }
}

#Preview {
    let store = ReferencePreviewData()
    return BotanicalLibraryView()
        .environment(BotanicalService(store: store))
        .frame(width: 900, height: 520)
}
