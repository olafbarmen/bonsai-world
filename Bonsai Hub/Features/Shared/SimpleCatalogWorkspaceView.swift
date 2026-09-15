//
//  SimpleCatalogWorkspaceView.swift
//  Bonsai World
//
//  Shared v1 list/detail for Economy and Workshop calendar/tasks notes.
//

import Foundation
import Observation
import SwiftUI

enum SimpleCatalogKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case workshopCalendar
    case workshopTasks
    case economyPurchases
    case economySales
    case economyExpenses
    case economyIncome
    case economyTreeValue
    case economyPotValue
    case economyInventoryValue
    case economyReports
    case socialContacts
    case socialLinks

    var id: Self { self }

    var title: String {
        switch self {
        case .workshopCalendar: "Calendar"
        case .workshopTasks: "Tasks"
        case .economyPurchases: "Purchases"
        case .economySales: "Sales"
        case .economyExpenses: "Expenses"
        case .economyIncome: "Income"
        case .economyTreeValue: "Tree Value"
        case .economyPotValue: "Pot Value"
        case .economyInventoryValue: "Inventory Value"
        case .economyReports: "Reports"
        case .socialContacts: "Contacts"
        case .socialLinks: "Links"
        }
    }

    var systemImage: String {
        switch self {
        case .workshopCalendar: "calendar"
        case .workshopTasks: "checklist"
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports:
            "sterlingsign.circle"
        case .socialContacts: "person.crop.circle"
        case .socialLinks: "link"
        }
    }

    var route: AppRoute {
        switch self {
        case .workshopCalendar: .workshopCalendar
        case .workshopTasks: .workshopTasks
        case .economyPurchases: .economyPurchases
        case .economySales: .economySales
        case .economyExpenses: .economyExpenses
        case .economyIncome: .economyIncome
        case .economyTreeValue: .economyTreeValue
        case .economyPotValue: .economyPotValue
        case .economyInventoryValue: .economyInventoryValue
        case .economyReports: .economyReports
        case .socialContacts: .socialContacts
        case .socialLinks: .socialLinks
        }
    }

    /// Secondary field label — Amount for Economy, Link for Social, hidden otherwise.
    var secondaryFieldTitle: String? {
        switch self {
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports:
            "Amount"
        case .socialContacts, .socialLinks:
            "Link"
        default:
            nil
        }
    }

    var titleFieldLabel: String {
        switch self {
        case .socialContacts: "Name"
        default: "Title"
        }
    }
}

struct SimpleCatalogEntry: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var kind: SimpleCatalogKind
    var title: String
    var notes: String
    var amountText: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        kind: SimpleCatalogKind,
        title: String,
        notes: String = "",
        amountText: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.notes = notes
        self.amountText = amountText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct LibrarySimpleCatalogFile: Codable, Hashable, Sendable {
    var schemaVersion: Int = 1
    var entries: [SimpleCatalogEntry] = []
}

@MainActor
protocol SimpleCatalogRepository: AnyObject {
    func getAll() -> [SimpleCatalogEntry]
    func get(id: UUID) -> SimpleCatalogEntry?
    @discardableResult
    func create(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry
    @discardableResult
    func update(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry
    func delete(id: UUID) throws
}

@Observable
@MainActor
final class LibrarySimpleCatalogRepository: SimpleCatalogRepository {
    private let storage: StorageService
    private var entries: [SimpleCatalogEntry] = []
    private var didLoad = false

    init(storage: StorageService) { self.storage = storage }

    func getAll() -> [SimpleCatalogEntry] {
        ensureLoaded(); return entries
    }
    func get(id: UUID) -> SimpleCatalogEntry? {
        ensureLoaded(); return entries.first { $0.id == id }
    }
    func create(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry {
        ensureLoaded()
        entries.append(entry)
        try persist()
        return entry
    }
    func update(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry {
        ensureLoaded()
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else {
            throw LibraryCatalogRepositoryError.notFound(entry.id)
        }
        entries[index] = entry
        try persist()
        return entry
    }
    func delete(id: UUID) throws {
        ensureLoaded()
        entries.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.simpleCatalogFileName
            ), !data.isEmpty else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            entries = try decoder.decode(LibrarySimpleCatalogFile.self, from: data).entries
        } catch {
            entries = []
        }
    }

    private func persist() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(LibrarySimpleCatalogFile(entries: entries))
        try storage.savePackageFile(relativePath: LibraryPackageLayout.simpleCatalogFileName, data: data)
    }
}

@MainActor
final class PreviewSimpleCatalogRepository: SimpleCatalogRepository {
    private var entries: [SimpleCatalogEntry] = []
    func getAll() -> [SimpleCatalogEntry] { entries }
    func get(id: UUID) -> SimpleCatalogEntry? { entries.first { $0.id == id } }
    func create(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry {
        entries.append(entry); return entry
    }
    func update(_ entry: SimpleCatalogEntry) throws -> SimpleCatalogEntry {
        guard let i = entries.firstIndex(where: { $0.id == entry.id }) else {
            throw LibraryCatalogRepositoryError.notFound(entry.id)
        }
        entries[i] = entry; return entry
    }
    func delete(id: UUID) throws { entries.removeAll { $0.id == id } }
}

@Observable
@MainActor
final class SimpleCatalogService {
    private var repository: any SimpleCatalogRepository
    private(set) var entries: [SimpleCatalogEntry] = []

    init(repository: any SimpleCatalogRepository) {
        self.repository = repository
        reload()
    }

    func attachRepository(_ repository: any SimpleCatalogRepository) {
        self.repository = repository
        reload()
    }

    private func reload() {
        entries = repository.getAll().sorted { $0.updatedAt > $1.updatedAt }
    }

    func entries(kind: SimpleCatalogKind) -> [SimpleCatalogEntry] {
        entries.filter { $0.kind == kind }
    }

    func entry(id: UUID) -> SimpleCatalogEntry? {
        entries.first { $0.id == id }
    }

    @discardableResult
    func create(kind: SimpleCatalogKind, title: String, notes: String, amountText: String) throws -> SimpleCatalogEntry {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw LibraryCatalogRepositoryError.invalid("Enter a title.")
        }
        let saved = try repository.create(
            SimpleCatalogEntry(kind: kind, title: trimmed, notes: notes, amountText: amountText)
        )
        reload()
        return saved
    }

    func delete(id: UUID) throws {
        try repository.delete(id: id)
        reload()
    }
}

struct SimpleCatalogWorkspaceView: View {
    let kind: SimpleCatalogKind

    @Environment(AppState.self) private var appState
    @Environment(SimpleCatalogService.self) private var service
    @State private var isCreatePresented = false
    @State private var title = ""
    @State private var notes = ""
    @State private var amountText = ""

    private var selectedID: UUID? {
        appState.selectedSimpleCatalogEntryID(for: kind)
    }

    var body: some View {
        Group {
            if let selectedID, let entry = service.entry(id: selectedID), entry.kind == kind {
                detail(entry)
            } else {
                list
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(kind.title)
        .sheet(isPresented: $isCreatePresented) {
            NavigationStack {
                Form {
                    TextField(kind.titleFieldLabel, text: $title)
                    if let secondary = kind.secondaryFieldTitle {
                        TextField(secondary, text: $amountText)
                    }
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                .formStyle(.grouped)
                .navigationTitle("Add \(kind.title)")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { isCreatePresented = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create") {
                            if let entry = try? service.create(
                                kind: kind,
                                title: title,
                                notes: notes,
                                amountText: amountText
                            ) {
                                appState.setSelectedSimpleCatalogEntryID(entry.id, for: kind)
                                isCreatePresented = false
                                title = ""; notes = ""; amountText = ""
                            }
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .frame(minWidth: 420, minHeight: 320)
        }
        .onAppear { consumeWantsNewSimpleCatalog() }
        .onChange(of: appState.wantsNewSimpleCatalogKind) { _, pending in
            guard pending == kind else { return }
            consumeWantsNewSimpleCatalog()
        }
    }

    private func consumeWantsNewSimpleCatalog() {
        guard appState.wantsNewSimpleCatalogKind == kind else { return }
        isCreatePresented = true
        appState.wantsNewSimpleCatalogKind = nil
    }

    private var list: some View {
        let items = service.entries(kind: kind)
        return ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                Text(kind.title).font(FaloTypography.headline)
                DetailCard(title: kind.title) {
                    if items.isEmpty {
                        Text("No entries yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(items) { entry in
                            Button {
                                appState.setSelectedSimpleCatalogEntryID(entry.id, for: kind)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(entry.title)
                                        .font(FaloCardTypography.fieldValue)
                                        .foregroundStyle(.primary)
                                    if !entry.amountText.isEmpty {
                                        Text(entry.amountText)
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .faloScrollSurface()
    }

    private func detail(_ entry: SimpleCatalogEntry) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                HStack {
                    Button("All \(kind.title)") {
                        appState.setSelectedSimpleCatalogEntryID(nil, for: kind)
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                    Button("Delete", role: .destructive) {
                        try? service.delete(id: entry.id)
                        appState.setSelectedSimpleCatalogEntryID(nil, for: kind)
                    }
                    .buttonStyle(.borderless)
                }
                Text(entry.title).font(FaloTypography.pageTitle)
                if !entry.amountText.isEmpty {
                    Text(entry.amountText).foregroundStyle(.secondary)
                }
                if !entry.notes.isEmpty {
                    DetailCard(title: "Notes") {
                        Text(entry.notes)
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .faloScrollSurface()
    }
}
