//
//  PotBrandPreviewData.swift
//  Bonsai World
//
//  Seed Reference Data v1 — curated Brand/Kiln and Maker/Potter catalog.
//  Quality over quantity. Notes are Bonsai World originals; source URLs are
//  research provenance only. No external stamp images are embedded.
//
//  Stable UUIDs (v5) so re-seeding does not break pot links for the same names.
//  Identity input is intentionally `v{seedVersion}:brand:{normalizedName}` /
//  `v{seedVersion}:maker:{brandKey}:{normalizedName}` — do NOT change the
//  namespace, version prefix, or name formula for existing seed rows, or existing
//  Pot.brandID / Pot.makerID references will break. Prefer documenting this
//  stability over introducing a parallel “canonical key” that would re-mint IDs.
//

import Foundation

enum PotBrandPreviewData {
    /// Bump when curated seed content/structure changes. Migration replaces system
    /// rows when persisted ``seedVersion`` is lower, keeping user-created rows.
    static let seedVersion = 1

    static let namespace = UUID(uuidString: "10000000-0000-4000-8000-B07A010A2001")!

    static let all: [PotBrand] = catalog.brands
    static let makers: [PotMaker] = catalog.makers

    private static let catalog: Catalog = build()

    static func brandID(named name: String) -> UUID {
        ReferencePreviewSeed.uuidV5(
            namespace: namespace,
            name: "v\(seedVersion):brand:\(ReferencePreviewSeed.normalized(name))"
        )
    }

    static func makerID(named name: String, brand: String?) -> UUID {
        let brandKey = brand.map(ReferencePreviewSeed.normalized) ?? "_"
        return ReferencePreviewSeed.uuidV5(
            namespace: namespace,
            name: "v\(seedVersion):maker:\(brandKey):\(ReferencePreviewSeed.normalized(name))"
        )
    }

    private struct Catalog {
        var brands: [PotBrand]
        var makers: [PotMaker]
    }

    private static let verified: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 9
        components.day = 2
        return Calendar(identifier: .gregorian).date(from: components) ?? .distantPast
    }()

    private static func build() -> Catalog {
        var brands: [PotBrand] = []
        var makers: [PotMaker] = []
        var brandSort = 0

        let tokonameSource = "Tokoname Bonsai Pot Makers (Tokoname Pottery Cooperative)"
        let tokonameURL = "http://www.tokoname.or.jp/bonsai/maker-e.htm"
        let ebpcSource = "European Bonsai Potter Collective (research index)"
        let ebpcURL = "https://www.europeanbonsaipottercollective.com/"

        func addBrand(
            _ name: String,
            kind: PotBrandKind,
            country: String,
            origin: String = "",
            notes: String = "",
            stampKnown: PotStampKnowledge = .unknown,
            sourceName: String = "",
            sourceURL: String = ""
        ) {
            brandSort += 1
            brands.append(
                PotBrand(
                    id: brandID(named: name),
                    name: name,
                    kind: kind,
                    country: country,
                    originText: origin,
                    notes: notes,
                    stampKnown: stampKnown,
                    sourceName: sourceName,
                    sourceURL: sourceURL,
                    verificationNotes: "Seed Reference Data v1 — relationships only where documented.",
                    lastVerified: verified,
                    isSystemSeed: true,
                    sortOrder: brandSort
                )
            )
        }

        func addMaker(
            _ name: String,
            brand: String?,
            country: String,
            type: PotMakerType = .individualPotter,
            notes: String = "",
            stampKnown: PotStampKnowledge = .unknown,
            sourceName: String = "",
            sourceURL: String = ""
        ) {
            if let brand {
                precondition(
                    brands.contains { $0.id == brandID(named: brand) },
                    "Missing brand seed '\(brand)' for maker '\(name)'"
                )
            }
            let brandUUID = brand.map { brandID(named: $0) }
            let makerSort: Int
            if let brandUUID {
                makerSort = makers.filter { $0.brandID == brandUUID }.count + 1
            } else {
                makerSort = makers.filter { $0.brandID == nil }.count + 1
            }
            makers.append(
                PotMaker(
                    id: makerID(named: name, brand: brand),
                    name: name,
                    brandID: brandUUID,
                    country: country,
                    makerType: type,
                    notes: notes,
                    stampKnown: stampKnown,
                    sourceName: sourceName,
                    sourceURL: sourceURL,
                    verificationNotes: "Seed Reference Data v1 — generation/period left empty unless documented.",
                    lastVerified: verified,
                    isSystemSeed: true,
                    sortOrder: makerSort
                )
            )
        }

        /// Brand + linked maker (documented trade name / kiln relationship).
        func linked(
            brand: String,
            kind: PotBrandKind = .kiln,
            maker: String,
            country: String,
            origin: String = "",
            type: PotMakerType = .individualPotter,
            brandNotes: String = "",
            stampKnown: PotStampKnowledge = .yes,
            sourceName: String,
            sourceURL: String
        ) {
            if !brands.contains(where: { $0.id == brandID(named: brand) }) {
                addBrand(
                    brand,
                    kind: kind,
                    country: country,
                    origin: origin,
                    notes: brandNotes,
                    stampKnown: stampKnown,
                    sourceName: sourceName,
                    sourceURL: sourceURL
                )
            }
            addMaker(
                maker,
                brand: brand,
                country: country,
                type: type,
                stampKnown: stampKnown,
                sourceName: sourceName,
                sourceURL: sourceURL
            )
        }

        // MARK: Japan — Tokoname (1–39 linked; 40–50 brand-only)

        linked(brand: "Yamaaki", maker: "Kataoka Toshio", country: "Japan", origin: "Tokoname", brandNotes: "Tokoname bonsai kiln.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Koshousen", maker: "Kataoka Sadamitsu", country: "Japan", origin: "Tokoname", brandNotes: "Tokoname trade name; keep distinct from Yamaaki.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Kakuzan", maker: "Watanabe Kakuyuki", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Kouhou", maker: "Watanabe Kouji", country: "Japan", origin: "Tokoname", brandNotes: "Distinct trade name from Kakuzan.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Seizan", maker: "Kataoka Makoto", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Reihou", maker: "Kataoka Katsushi", country: "Japan", origin: "Tokoname", brandNotes: "Tokoname trade name used by more than one documented potter — keep makers distinct.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Yoshimura / Shuuhou", maker: "Kataoka Susumu", country: "Japan", origin: "Tokoname", brandNotes: "Yoshimura kiln; Shuuhou trade name. Keep distinct from Hidemi.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Hidemi", maker: "Kataoka Hidemi", country: "Japan", origin: "Tokoname", brandNotes: "Distinct seed record from Yoshimura / Shuuhou.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Bigei", maker: "Hirata Atsumi", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Youzan", maker: "Shimizu Masakazu", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Hideaki", maker: "Shimizu Hideaki", country: "Japan", origin: "Tokoname", brandNotes: "Distinct trade-name record from Youzan.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Izumi-ya", maker: "Matsushita Masuo", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Touyou", maker: "Matsumoto Takeshi", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Kaneshou", maker: "Watanabe Masami", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Ikkou", maker: "Watanabe Kazuhiro", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Maruhei", maker: "Watanabe Kei", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Gyouzan", maker: "Nakano Yukizou", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Yuuji", maker: "Nakano Yuuji", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Yamafusa", maker: "Koie Takehiko", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Kouyou", maker: "Aiba Kouichirou", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Jukou", maker: "Aiba Kuniaki", country: "Japan", origin: "Tokoname", brandNotes: "Distinct trade-name record from Kouyou.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Hattori", maker: "Hattori Tomoyuki", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Shibakatsu", maker: "Shibata Shouichi", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Kyokusei", maker: "Mizukami Kiyoshi", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Akira Shouzan", maker: "Watanabe Akira", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Jukousan", maker: "Watanabe Fumikazu", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Shigeharu", maker: "Sawada Shigeharu", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Yamahan", maker: "Yamada Shigehiro", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Ryuugaku", maker: "Matsumoto Takashi", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        // Second documented Reihou potter — same Brand name, distinct Maker (do not merge people).
        addMaker("Matsushita Reiji", brand: "Reihou", country: "Japan", stampKnown: .yes, sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Bonsai", maker: "Matsushita Hiroyuki", country: "Japan", origin: "Tokoname", brandNotes: "Tokoname trade name as listed by the cooperative.", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Sanpou", maker: "Saida Miyozou", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Keizan", maker: "Hisada Shizuo", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Mizukawa", maker: "Mizukawa Kiyohei", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Morishita", maker: "Morishita Isamu", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Ikkoudou", maker: "Koie Kiyokazu", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Houzan", maker: "Mizukami Mineo", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Toshitaka", maker: "Yamamoto Toshitaka", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)
        linked(brand: "Hekisui", maker: "Mizukami Shinji", country: "Japan", origin: "Tokoname", sourceName: tokonameSource, sourceURL: tokonameURL)

        for brandOnly in [
            "Suishouen", "Senkouen", "Kaiyou", "Yamagen", "Kameoka",
            "Marushi", "Toushou", "Marutsune", "Nizamatsu", "Sankyou", "Yamakou"
        ] {
            addBrand(
                brandOnly,
                kind: .kiln,
                country: "Japan",
                origin: "Tokoname",
                notes: "Tokoname Brand/Kiln in seed v1 without a confidently linked individual Maker/Potter.",
                stampKnown: .unknown,
                sourceName: tokonameSource,
                sourceURL: tokonameURL
            )
        }

        // MARK: France

        linked(brand: "Amdouni Bonsai Pots", kind: .brand, maker: "Sami Amdouni", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Bruno Auvinet", kind: .brand, maker: "Bruno Auvinet", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Sabine Besnard", brand: nil, country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "FURO", kind: .brand, maker: "Florent Coirier", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Greg Ceramics", kind: .brand, maker: "Gregory Delattre", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Lotus Bonsai Studio", kind: .brand, maker: "Giang Nyugen", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Pierre Rousseau", brand: nil, country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Terrajade", kind: .brand, maker: "Julien Le Guen", country: "France", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Germany

        linked(brand: "M.B. Bonsaischalen", kind: .brand, maker: "Marc Berenbrinker", country: "Germany", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Englert Keramik", kind: .brand, maker: "Martin Englert", country: "Germany", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Akzent und Bonsai Schalen", kind: .brand, maker: "Roman Husmann", country: "Germany", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Walter Venne", brand: nil, country: "Germany", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Italy

        addMaker("Igor Carino", brand: nil, country: "Italy", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Kanso Ceramica", kind: .brand, maker: "Rosa Turco", country: "Italy", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Shibusa Bonsai Pots", kind: .brand, maker: "Lorenzo Penello", country: "Italy", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Yaruki Ceramics", kind: .brand, maker: "Giuseppe Lombardo", country: "Italy", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Spain

        linked(brand: "Guerao", kind: .brand, maker: "Jose Antonio Guerao Navarro", country: "Spain", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Kamereon Pots", kind: .brand, maker: "Tony & Nuria Amago", country: "Spain", type: .partnership, sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Maidenhair Ceramics", kind: .brand, maker: "Nick Hopes", country: "Spain", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "M.J.G. Ceramica", kind: .brand, maker: "Maria Jose Gonzalez", country: "Spain", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Sweden

        linked(brand: "CJ Ceramics", kind: .brand, maker: "Carina Jern", country: "Sweden", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Gramming Bonsai Pots", kind: .brand, maker: "Tomas Gramming", country: "Sweden", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Holvila Bonsai Pots", kind: .brand, maker: "Thor Holvila", country: "Sweden", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Slovenia

        linked(brand: "Atelier Bonsai Element", kind: .brand, maker: "Eric Krysovensky", country: "Slovenia", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Me & Raimondi", kind: .brand, maker: "Matjaz Raimondi / Nastja Legvart", country: "Slovenia", type: .partnership, sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Switzerland

        linked(brand: "Fukurou Ceramics", kind: .brand, maker: "Patrik Luthi", country: "Switzerland", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Kawasemi Studios", kind: .brand, maker: "Nadja & Sandro Tschudin", country: "Switzerland", type: .partnership, sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Jürg Stäheli", brand: nil, country: "Switzerland", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "SlabndBonsai", kind: .brand, maker: "Robin Löhrer", country: "Switzerland", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Netherlands

        linked(brand: "Fusion Ceramics", kind: .brand, maker: "Niels van der Wal", country: "Netherlands", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Michal Mokry", brand: nil, country: "Netherlands", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Denmark

        linked(brand: "E.B.L. Pots", kind: .brand, maker: "Elsebeth Bruun Ludvigsen", country: "Denmark", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: Czech Republic

        addMaker("Tom Benda", brand: nil, country: "Czech Republic", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "K.M. Bonsai Pots", kind: .brand, maker: "Jakub Malcharek", country: "Czech Republic", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Jiří Konopáč", brand: nil, country: "Czech Republic", sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Miroslav Znamenáček", brand: nil, country: "Czech Republic", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: United Kingdom

        addMaker("Bryan Albright", brand: nil, country: "United Kingdom", stampKnown: .yes, sourceName: ebpcSource, sourceURL: ebpcURL)
        addMaker("Ian Baillie", brand: nil, country: "United Kingdom", stampKnown: .yes, sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "China Mist", kind: .brand, maker: "Steve Kitchman", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Dragonfly Bonsai Pots", kind: .brand, maker: "Graham Simpson", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Erin Bonsai Pots", kind: .brand, maker: "Vic Harris", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Kingdom Bonsai Pots", kind: .brand, maker: "Enda Coyne", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "P.A.S. Pottery", kind: .brand, maker: "Patricia", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Paul Rogers Ceramics", kind: .brand, maker: "Paul Rogers", country: "United Kingdom", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(brand: "Walsall Studio Ceramics", kind: .brand, maker: "Ian Smith / Stuart Bell", country: "United Kingdom", type: .partnership, brandNotes: "UK workshop; partnership makers as documented.", sourceName: ebpcSource, sourceURL: ebpcURL)

        // MARK: United States

        let usSource = "American bonsai ceramics directories (research index)"
        linked(brand: "Yakimono no Kokoro", kind: .brand, maker: "Dale Cochoy", country: "United States", sourceName: usSource, sourceURL: "")
        for name in [
            "Rob Addonizio", "Jim Gremel", "Sara Rayner", "Chuck Iker", "Sandi McFarland",
            "Dave Lowman", "Rob MacGregor", "Diane Thoman", "Ben Gutman", "Matthew Harhager",
            "Ron Lang", "Keith Taylor", "Nick Lenz", "Don Gould", "Max Braverman",
            "Sharon Muth", "Richard Robertson", "Michael Hagedorn"
        ] {
            addMaker(name, brand: nil, country: "United States", sourceName: usSource, sourceURL: "")
        }

        // MARK: Other

        addMaker("Alex Imbo", brand: nil, country: "Canada", sourceName: usSource, sourceURL: "")
        linked(brand: "O-Yaku", kind: .brand, maker: "Shay Cohen", country: "Israel", sourceName: ebpcSource, sourceURL: ebpcURL)
        linked(
            brand: "Willow Bonsai",
            kind: .brand,
            maker: "Anthony & Mavourneen Smith",
            country: "South Africa / United States",
            type: .partnership,
            brandNotes: "Documented South Africa / United States relationship preserved as supplied.",
            sourceName: ebpcSource,
            sourceURL: ebpcURL
        )

        return Catalog(brands: brands, makers: makers)
    }
}

enum PotMakerPreviewData {
    static let all: [PotMaker] = PotBrandPreviewData.makers
}
