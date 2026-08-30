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
        return officialBonsaiName(
            genus: gen,
            species: spe,
            cultivar: cul,
            acquisitionYear: acquisitionYear,
            sequence: sequence
        )
    }

    /// Same official format as Add Tree, with fallbacks when lookup strings are empty.
    /// 1) Genus / species / cultivar names  2) Botanical Name  3) GEN/SPE/CUL from an existing official name.
    static func makeGeneratedBonsaiName(
        genusName: String,
        speciesName: String,
        cultivarName: String?,
        botanicalName: String,
        existingBonsaiName: String,
        acquisitionYear: Int,
        sequence: Int
    ) -> String {
        let botanical = namingParts(fromBotanicalName: botanicalName)
        let genus = firstNonEmpty(genusName, botanical.genus)
        let species = firstNonEmpty(speciesName, botanical.species)
        let cultivar = firstNonEmpty(cultivarName, botanical.cultivar)

        let fromNames = makeBonsaiName(
            genusName: genus,
            speciesName: species,
            cultivarName: cultivar,
            acquisitionYear: acquisitionYear,
            sequence: sequence
        )
        if !fromNames.isEmpty { return fromNames }

        guard let existing = parseOfficialBonsaiName(existingBonsaiName) else { return "" }
        return officialBonsaiName(
            genus: existing.genusAbbreviation,
            species: existing.speciesAbbreviation,
            cultivar: existing.cultivarAbbreviation,
            acquisitionYear: acquisitionYear,
            sequence: sequence
        )
    }

    /// Genus, species epithet, and optional cultivar from a stored Botanical Name
    /// (`Genus epithet 'Cultivar'`).
    static func namingParts(fromBotanicalName name: String) -> (genus: String, species: String, cultivar: String?) {
        var remainder = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var cultivar: String?

        if let first = remainder.firstIndex(of: "'"),
           first < remainder.endIndex {
            let afterFirst = remainder.index(after: first)
            if let second = remainder[afterFirst...].firstIndex(of: "'") {
                let raw = String(remainder[afterFirst..<second])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                if !raw.isEmpty { cultivar = raw }
                remainder = String(remainder[..<first])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        let words = remainder.split(whereSeparator: { $0.isWhitespace }).map(String.init)
        let genus = words.first ?? ""
        let species = words.dropFirst().joined(separator: " ")
        return (genus, species, cultivar)
    }

    /// Acquisition calendar year for Bonsai Name generation.
    static func acquisitionYear(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: date)
    }

    /// Parses an official five-segment Bonsai Name (`GEN-SPE-CUL-YYYY-NNN`).
    static func parseOfficialBonsaiName(_ bonsaiName: String) -> (
        genusAbbreviation: String,
        speciesAbbreviation: String,
        cultivarAbbreviation: String,
        year: Int,
        sequence: Int
    )? {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: "-").map(String.init)
        guard parts.count == 5,
              parts[0].count == 3,
              parts[1].count == 3,
              parts[2].count == 3,
              parts[3].count == 4,
              let year = Int(parts[3]),
              let sequence = Int(parts[4]),
              parts[4].count == 3
        else { return nil }
        return (parts[0], parts[1], parts[2], year, sequence)
    }

    /// Parses the trailing sequence (`NNN`) from a Bonsai Name.
    static func parseBonsaiNameSequence(_ bonsaiName: String) -> Int? {
        parseOfficialBonsaiName(bonsaiName)?.sequence
    }

    /// Next sequence for a species: the lowest unused number among remaining trees
    /// (In Care and Former). Deleted trees free their number; sold / died keep theirs.
    static func nextSequence(
        forSpecies speciesID: UUID,
        existingTrees: [Tree]
    ) -> Int {
        let used = Set(
            existingTrees
                .filter { $0.speciesID == speciesID }
                .compactMap { parseBonsaiNameSequence($0.bonsaiName) }
        )
        var sequence = 1
        while used.contains(sequence) {
            sequence += 1
        }
        return sequence
    }

    // MARK: - Import compatibility

    /// Imported / legacy Names are kept as Display Name — never overwritten by botanical regeneration.
    static func preservedImportedName(_ existingName: String) -> String {
        existingName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func officialBonsaiName(
        genus: String,
        species: String,
        cultivar: String,
        acquisitionYear: Int,
        sequence: Int
    ) -> String {
        let nnn = String(format: "%03d", max(sequence, 1))
        return "\(genus)-\(species)-\(cultivar)-\(acquisitionYear)-\(nnn)"
    }

    private static func firstNonEmpty(_ values: String?...) -> String {
        for value in values {
            let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !trimmed.isEmpty { return trimmed }
        }
        return ""
    }
}

typealias TreeNaming = TreeNamingService
