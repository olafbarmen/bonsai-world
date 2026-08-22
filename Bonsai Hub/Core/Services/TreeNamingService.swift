//
//  TreeNamingService.swift
//  Bonsai World
//
//  Automatic tree naming (Excel Lists behaviour).
//  Lives outside the Tree domain model — models store the resulting strings.
//
//  Botanical Name: Genus Species ['Cultivar']
//  Tree Name:      cultivar, else botanical hierarchy
//  Bonsai Name:    GEN-SPE-CUL-YYYY-NNN (acquisition year; sequence per species)
//

import Foundation

enum TreeNamingService {

    // MARK: - Botanical display name

    /// Builds the botanical label from genus / species epithet / cultivar name strings.
    static func makeBotanicalName(
        genus: String,
        species: String,
        cultivar: String? = nil
    ) -> String {
        let binomial = binomial(genus: genus, species: species)
        let trimmedCultivar = cultivar?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !binomial.isEmpty else {
            return trimmedCultivar.isEmpty ? "" : "'\(trimmedCultivar)'"
        }
        guard !trimmedCultivar.isEmpty else {
            return binomial
        }
        return "\(binomial) '\(trimmedCultivar)'"
    }

    /// Genus + species epithet (or a full binomial already stored in `species`).
    static func binomial(genus: String, species: String) -> String {
        let g = genus.trimmingCharacters(in: .whitespacesAndNewlines)
        let s = species.trimmingCharacters(in: .whitespacesAndNewlines)
        if g.isEmpty { return s }
        if s.isEmpty { return g }
        if s.caseInsensitiveCompare(g) == .orderedSame
            || s.lowercased().hasPrefix(g.lowercased() + " ") {
            return s
        }
        return "\(g) \(s)"
    }

    // MARK: - Initial Tree Name (Display Name)

    /// Suggested Tree Name when a tree is first created.
    /// - Cultivar present → cultivar only (e.g. `Itoigawa`)
    /// - Otherwise → best label from the botanical hierarchy (binomial, else species, else genus)
    static func makeInitialTreeName(
        genus: String,
        species: String,
        cultivar: String? = nil
    ) -> String {
        let trimmedCultivar = cultivar?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !trimmedCultivar.isEmpty {
            return trimmedCultivar
        }
        return binomial(genus: genus, species: species)
    }

    // MARK: - Bonsai Name (GEN-SPE-CUL-YYYY-NNN)

    /// Placeholder when no cultivar is selected. Keeps the five-segment format intact.
    static let unspecifiedCultivarAbbreviation = "XXX"

    /// Official three-letter abbreviation derived from a botanical name
    /// (letters only, uppercased, first three — e.g. Acer → ACE, Deshojo → DES).
    static func makeAbbreviation(from name: String) -> String {
        let letters = name.unicodeScalars.filter { CharacterSet.letters.contains($0) }
        let upper = String(String.UnicodeScalarView(letters)).uppercased()
        guard !upper.isEmpty else { return "" }
        if upper.count >= 3 {
            return String(upper.prefix(3))
        }
        return upper.padding(toLength: 3, withPad: "X", startingAt: 0)
    }

    /// Builds the permanent Bonsai Name.
    /// - Year is the acquisition year (never registration / created date).
    /// - Sequence is caller-supplied (per species; never reused).
    /// - Missing cultivar → ``unspecifiedCultivarAbbreviation``.
    static func makeBonsaiName(
        genusName: String,
        speciesName: String,
        cultivarName: String? = nil,
        acquisitionYear: Int,
        sequence: Int
    ) -> String {
        let gen = makeAbbreviation(from: genusName)
        let spe = makeAbbreviation(from: speciesName)
        guard !gen.isEmpty, !spe.isEmpty else { return "" }

        let culRaw = makeAbbreviation(from: cultivarName ?? "")
        let cul = culRaw.isEmpty ? unspecifiedCultivarAbbreviation : culRaw
        let nnn = String(format: "%03d", max(sequence, 1))
        return "\(gen)-\(spe)-\(cul)-\(acquisitionYear)-\(nnn)"
    }

    /// Acquisition calendar year for Bonsai Name generation.
    static func acquisitionYear(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: date)
    }

    /// Parses the trailing sequence (`NNN`) from a Bonsai Name.
    static func parseBonsaiNameSequence(_ bonsaiName: String) -> Int? {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: "-").map(String.init)
        guard parts.count == 5,
              parts[0].count == 3,
              parts[1].count == 3,
              parts[2].count == 3,
              parts[3].count == 4,
              Int(parts[3]) != nil,
              let sequence = Int(parts[4]),
              parts[4].count == 3
        else { return nil }
        return sequence
    }

    /// Next sequence for a species: one past the high-water mark and any live trees.
    /// Deleted trees do not free numbers when `highWaterMark` is retained by the catalog.
    static func nextSequence(
        forSpecies speciesID: UUID,
        existingTrees: [Tree],
        highWaterMark: Int
    ) -> Int {
        let fromTrees = existingTrees
            .filter { $0.speciesID == speciesID }
            .compactMap { parseBonsaiNameSequence($0.bonsaiName) }
            .max() ?? 0
        return max(fromTrees, highWaterMark, 0) + 1
    }

    // MARK: - Import compatibility

    /// Imported / legacy Names are kept as Display Name — never overwritten by botanical regeneration.
    static func preservedImportedName(_ existingName: String) -> String {
        existingName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

typealias TreeNaming = TreeNamingService
