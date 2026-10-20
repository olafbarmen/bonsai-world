//
//  TreeOverviewPresence.swift
//  Bonsai World
//
//  Tree Overview View Mode — presence hero + primary modules.
//  Visual rhythm matches Dashboard (raised surface, spacing, section titles).
//  Edit Mode keeps the denser form layout elsewhere.
//

import SwiftUI

/// Quiet status chip — text + icon (status never relies on color alone).
struct TreeOverviewStatusChip: View {
    let title: String
    var systemImage: String?
    /// Stronger treatment for attention / problem states (Hero Health chip).
    var isEmphasized: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(isEmphasized ? BonsaiWorldColors.statusAttention : BonsaiWorldColors.accent)
            }
            Text(title)
                .font(FaloTypography.caption.weight(.medium))
                .foregroundStyle(isEmphasized ? BonsaiWorldColors.textPrimary : BonsaiWorldColors.textSecondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule(style: .continuous)
                .fill(
                    isEmphasized
                        ? BonsaiWorldColors.statusAttention.opacity(0.18)
                        : BonsaiWorldColors.accentSubtle
                )
        }
        .accessibilityElement(children: .combine)
    }
}

/// Dashboard-matching module chrome for Tree Overview primary sections.
struct TreeOverviewModuleCard<Content: View>: View {
    let title: String
    /// Optional trailing control in the title row (e.g. “View all”).
    var titleAccessory: AnyView? = nil
    /// When true, card fills sibling row height (equal row tops/bottoms).
    var fillsRowHeight: Bool = false
    /// Secondary modules use a quieter title so Level 2 care modules stay easier to scan.
    var usesSecondaryTitle: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: TreeOverviewSpacing.titleToContent) {
            HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                Text(title)
                    .font(usesSecondaryTitle ? FaloTypography.caption.weight(.medium) : FaloTypography.sectionHeading)
                    .foregroundStyle(
                        usesSecondaryTitle ? BonsaiWorldColors.textSecondary : BonsaiWorldColors.textPrimary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)

                if let titleAccessory {
                    titleAccessory
                }
            }

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if fillsRowHeight {
                Spacer(minLength: 0)
            }
        }
        .padding(TreeOverviewSpacing.cardPadding)
        .frame(
            maxWidth: .infinity,
            maxHeight: fillsRowHeight ? .infinity : nil,
            alignment: .topLeading
        )
        .faloRaisedSurface()
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

// MARK: - Hero (full content width, 4 column slots inside one surface)

struct TreeOverviewHeroBanner<Photo: View, CurrentState: View, Species: View>: View {
    let bonsaiName: String
    let botanicalName: String
    let nickname: String
    let genusName: String
    let speciesName: String
    let cultivarName: String
    let propagation: String
    let origin: String
    let countryOfOrigin: String
    let healthTitle: String
    let healthSystemImage: String
    /// When true, Health chip uses attention emphasis (Stable / Thriving stay quiet).
    var healthNeedsAttention: Bool = false
    let locationTitle: String?
    let stageTitle: String?
    let notesExcerpt: String?
    let photoCount: Int
    /// Dashboard column width — photo / summary+identity / Current State / Species.
    let columnWidth: CGFloat
    /// Fixed photo well height; image scales to fit (aspect preserved).
    let photoHeight: CGFloat
    @ViewBuilder var photo: () -> Photo
    @ViewBuilder var currentState: () -> CurrentState
    @ViewBuilder var species: () -> Species

    /// ~50% larger than ``FaloTypography/headline`` (~13 → ~20).
    private var nameFont: Font { .system(size: 20, weight: .semibold, design: .default) }

    var body: some View {
        HStack(alignment: .bottom, spacing: TreeOverviewSpacing.cardGap) {
            photoColumn
                .frame(width: columnWidth, height: photoHeight, alignment: .bottom)

            summaryColumn
                .frame(width: columnWidth, height: photoHeight, alignment: .topLeading)

            currentState()
                .frame(width: columnWidth, height: photoHeight, alignment: .topLeading)

            species()
                .frame(width: columnWidth, height: photoHeight, alignment: .topLeading)
        }
        .padding(TreeOverviewSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .faloRaisedSurface()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tree overview")
    }

    private var photoColumn: some View {
        let wellWidth = min(columnWidth, TreeOverviewGridMetrics.heroPhotoWidth)
        return HStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                photo()
                    .frame(width: wellWidth, height: photoHeight, alignment: .center)
                if photoCount > 0 {
                    Text(photoCount == 1 ? "1 photo" : "\(photoCount) photos")
                        .font(FaloTypography.caption.weight(.medium))
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background {
                            Capsule(style: .continuous)
                                .fill(BonsaiWorldColors.canvas.opacity(0.92))
                        }
                        .padding(FaloSpacing.small)
                        .accessibilityLabel(photoCount == 1 ? "1 photo" : "\(photoCount) photos")
                }
            }
            .frame(width: wellWidth, height: photoHeight)
            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))

            Spacer(minLength: 0)
        }
        .frame(width: columnWidth, height: photoHeight, alignment: .leading)
    }

    private var summaryColumn: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(display(bonsaiName, empty: "Untitled Tree"))
                .font(nameFont)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .lineLimit(2)

            HStack(spacing: FaloSpacing.small) {
                TreeOverviewStatusChip(
                    title: healthTitle,
                    systemImage: healthSystemImage,
                    isEmphasized: healthNeedsAttention
                )
                if let locationTitle {
                    TreeOverviewStatusChip(title: locationTitle, systemImage: "mappin.and.ellipse")
                }
                if let stageTitle {
                    TreeOverviewStatusChip(title: stageTitle, systemImage: "leaf")
                }
            }

            if let notesExcerpt {
                Text("“\(notesExcerpt)”")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .italic()
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            identityCard
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    /// Botanical Name → Origin in its own box (same rhythm as Current State / Species).
    private var identityCard: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DashboardMetricRow(title: "Botanical Name", value: display(botanicalName), compact: true)
            DashboardMetricRow(title: "Nickname", value: display(nickname), compact: true)
            DashboardMetricRow(title: "Genus", value: display(genusName), compact: true)
            DashboardMetricRow(title: "Species", value: display(speciesName), compact: true)
            DashboardMetricRow(title: "Cultivar", value: display(cultivarName), compact: true)
            DashboardMetricRow(title: "Propagation", value: display(propagation), compact: true)
            DashboardMetricRow(title: "Origin", value: display(origin), compact: true)
            DashboardMetricRow(title: "Country of Origin", value: display(countryOfOrigin), compact: true)

            Spacer(minLength: 0)
        }
        .padding(FaloSpacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .fill(BonsaiWorldColors.raisedSurface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Identity")
    }

    private func display(_ value: String, empty: String = FaloDisplayValue.empty) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? empty : trimmed
    }
}

struct TreeOverviewSpeciesTeaser: View {
    let scientificName: String
    let commonName: String
    let summaryLine: String
    var onOpenProfile: (() -> Void)?
    var fillsRowHeight: Bool = false

    /// Empty Species Library slot — keeps the Overview column box when no Knowledge profile exists.
    static func notRegistered(botanicalName: String = "", fillsRowHeight: Bool = false) -> TreeOverviewSpeciesTeaser {
        TreeOverviewSpeciesTeaser(
            scientificName: botanicalName.trimmingCharacters(in: .whitespacesAndNewlines),
            commonName: "",
            summaryLine: "Species not yet registered in library",
            onOpenProfile: nil,
            fillsRowHeight: fillsRowHeight
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Image(systemName: "leaf")
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(BonsaiWorldColors.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityHidden(true)

            if !scientificName.isEmpty {
                Text(scientificName)
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(2)
            }

            if !commonName.isEmpty {
                Text(commonName)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(1)
            }

            if !summaryLine.isEmpty {
                Text(summaryLine)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let onOpenProfile {
                Button("View species profile", action: onOpenProfile)
                    .buttonStyle(.borderless)
                    .font(FaloTypography.caption.weight(.medium))
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .padding(.top, FaloSpacing.xSmall)
            }

            if fillsRowHeight {
                Spacer(minLength: 0)
            }
        }
        .padding(FaloSpacing.small)
        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: fillsRowHeight ? .infinity : nil, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .fill(BonsaiWorldColors.accentSubtle.opacity(0.55))
        }
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Species")
    }
}

// MARK: - Primary modules

struct TreeOverviewCurrentStateCard: View {
    let rows: [(label: String, value: String, systemImage: String, action: (() -> Void)?)]
    var fillsRowHeight: Bool = false

    init(
        rows: [(label: String, value: String, systemImage: String)],
        fillsRowHeight: Bool = false
    ) {
        self.rows = rows.map { ($0.label, $0.value, $0.systemImage, nil) }
        self.fillsRowHeight = fillsRowHeight
    }

    init(
        actionableRows: [(label: String, value: String, systemImage: String, action: (() -> Void)?)],
        fillsRowHeight: Bool = false
    ) {
        self.rows = actionableRows
        self.fillsRowHeight = fillsRowHeight
    }

    var body: some View {
        TreeOverviewModuleCard(title: "Current State", fillsRowHeight: fillsRowHeight) {
            if rows.isEmpty {
                Text("No growing details yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            } else {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    if let action = row.action {
                        DashboardCardTapButton(action: action) {
                            DashboardMetricRow(
                                title: row.label,
                                value: row.value,
                                systemImage: row.systemImage,
                                compact: true
                            )
                        }
                    } else {
                        DashboardMetricRow(
                            title: row.label,
                            value: row.value,
                            systemImage: row.systemImage,
                            compact: true
                        )
                    }
                }
            }
        }
    }
}

struct TreeOverviewHealthCareCard: View {
    let healthTitle: String
    let healthSystemImage: String
    /// When true, Health & Care surfaces health (attention / problem). Hero always shows the chip.
    let healthNeedsAttention: Bool
    /// What is wrong. Omitted when empty.
    var healthCause: String = ""
    /// Always outdoors vs seasonal in/out — distinct from Location.
    var placementStrategy: TreePlacementStrategy? = nil
    var onPlacementStrategyChange: ((TreePlacementStrategy) -> Void)? = nil
    /// Summer vs winter mode (shown when strategy is seasonal).
    var seasonPlacement: TreeSeasonPlacement? = nil
    var onSeasonPlacementChange: ((TreeSeasonPlacement) -> Void)? = nil
    /// Existing relative date only — omit the row when nil (no "-" placeholder).
    var lastWateredLabel: String? = nil
    var lastFertilizedLabel: String? = nil
    var fillsRowHeight: Bool = false

    var body: some View {
        TreeOverviewModuleCard(title: "Health & Care", fillsRowHeight: fillsRowHeight) {
            if healthNeedsAttention {
                DashboardMetricRow(
                    title: "Health",
                    value: healthTitle,
                    systemImage: healthSystemImage,
                    isEmphasized: true,
                    compact: true
                )
            }
            if !healthCause.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                DashboardMetricRow(
                    title: "Cause",
                    value: healthCause,
                    systemImage: "text.alignleft",
                    compact: true
                )
            }
            if let placementStrategy {
                strategyRow(placementStrategy)
            }
            if let seasonPlacement, placementStrategy == .seasonal {
                seasonRow(seasonPlacement)
            }
            if let lastWateredLabel {
                DashboardMetricRow(
                    title: "Last Watered",
                    value: lastWateredLabel,
                    systemImage: "drop",
                    compact: true
                )
            }
            if let lastFertilizedLabel {
                DashboardMetricRow(
                    title: "Last Fertilized",
                    value: lastFertilizedLabel,
                    systemImage: "leaf.circle",
                    compact: true
                )
            }
        }
    }

    @ViewBuilder
    private func strategyRow(_ strategy: TreePlacementStrategy) -> some View {
        if let onPlacementStrategyChange {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Label("Placement strategy", systemImage: "arrow.triangle.2.circlepath")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                Picker("Placement strategy", selection: Binding(
                    get: { strategy },
                    set: { onPlacementStrategyChange($0) }
                )) {
                    ForEach(TreePlacementStrategy.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            DashboardMetricRow(
                title: "Placement strategy",
                value: strategy.title,
                systemImage: "arrow.triangle.2.circlepath",
                compact: true
            )
        }
    }

    @ViewBuilder
    private func seasonRow(_ season: TreeSeasonPlacement) -> some View {
        if let onSeasonPlacementChange {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Label("Season", systemImage: "leaf.arrow.triangle.circlepath")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                Picker("Season", selection: Binding(
                    get: { season },
                    set: { onSeasonPlacementChange($0) }
                )) {
                    ForEach(TreeSeasonPlacement.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            DashboardMetricRow(
                title: "Season",
                value: season.title,
                systemImage: "leaf.arrow.triangle.circlepath",
                compact: true
            )
        }
    }
}

/// Identity field list — kept for Edit Mode / reuse; Overview hero embeds Identity inline.
struct TreeOverviewIdentityCard: View {
    let bonsaiName: String
    let botanicalName: String
    let nickname: String
    let genusName: String
    let speciesName: String
    let cultivarName: String
    let propagation: String
    let origin: String
    let countryOfOrigin: String
    var fillsRowHeight: Bool = false

    var body: some View {
        TreeOverviewModuleCard(title: "Identity", fillsRowHeight: fillsRowHeight) {
            DashboardMetricRow(title: "Bonsai Name", value: display(bonsaiName), compact: true)
            DashboardMetricRow(title: "Botanical Name", value: display(botanicalName), compact: true)
            DashboardMetricRow(title: "Nickname", value: display(nickname), compact: true)
            DashboardMetricRow(title: "Genus", value: display(genusName), compact: true)
            DashboardMetricRow(title: "Species", value: display(speciesName), compact: true)
            DashboardMetricRow(title: "Cultivar", value: display(cultivarName), compact: true)
            DashboardMetricRow(title: "Propagation", value: display(propagation), compact: true)
            DashboardMetricRow(title: "Origin", value: display(origin), compact: true)
            DashboardMetricRow(title: "Country of Origin", value: display(countryOfOrigin), compact: true)
        }
    }

    private func display(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? FaloDisplayValue.empty : trimmed
    }
}

struct TreeOverviewAdditionalInfoCard: View {
    let acquired: String
    let source: String
    let value: String
    var fillsRowHeight: Bool = false

    var body: some View {
        TreeOverviewModuleCard(title: "Additional Information", fillsRowHeight: fillsRowHeight) {
            DashboardMetricRow(title: "Acquired", value: display(acquired), systemImage: "calendar", compact: true)
            DashboardMetricRow(title: "Source", value: display(source), systemImage: "shippingbox", compact: true)
            DashboardMetricRow(title: "Value", value: display(value), systemImage: "banknote", compact: true)
        }
    }

    private func display(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? FaloDisplayValue.empty : trimmed
    }
}

struct TreeSocialShareCard: View {
    let level: SocialShareLevel
    let isSocialEnabled: Bool
    var isEditing: Bool = false
    var onChange: (SocialShareLevel) -> Void

    var body: some View {
        Group {
            if isEditing {
                DetailCard(title: "Social") {
                    content
                }
            } else {
                TreeOverviewModuleCard(title: "Social") {
                    content
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isSocialEnabled {
            Picker("Share Level", selection: Binding(
                get: { level },
                set: { onChange($0) }
            )) {
                ForEach(SocialShareLevel.allCases) { shareLevel in
                    Text(shareLevel.title).tag(shareLevel)
                }
            }
            .labelsHidden()
            Text(level.detail)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Text("Preference only for now — no live share feed or publishing yet.")
                .font(FaloTypography.caption)
                .foregroundStyle(.tertiary)
        } else {
            Text(level.isShared
                ? "Share level is \(level.title), but Social is off in Settings — nothing is shared yet."
                : "Social sharing is not active yet. Turn it on in Settings when you want to use it; until then this is only a saved preference.")
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
        }
    }
}

struct TreeOverviewCollectionsCard: View {
    let items: [(id: UUID, name: String)]
    var onSelect: ((UUID) -> Void)? = nil
    var fillsRowHeight: Bool = false

    var body: some View {
        TreeOverviewModuleCard(title: "Collections", fillsRowHeight: fillsRowHeight) {
            if items.isEmpty {
                Text("Not in any Collection")
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            } else {
                CollectionTokenFlowLayoutAdapter(items: items, onSelect: onSelect)
            }
        }
    }
}

/// Lightweight wrap of collection name chips.
private struct CollectionTokenFlowLayoutAdapter: View {
    let items: [(id: UUID, name: String)]
    var onSelect: ((UUID) -> Void)?

    var body: some View {
        OverviewChipFlowLayout(spacing: FaloSpacing.small) {
            ForEach(items, id: \.id) { item in
                if let onSelect {
                    Button {
                        onSelect(item.id)
                    } label: {
                        TreeOverviewStatusChip(title: item.name, systemImage: "square.stack.3d.up")
                    }
                    .buttonStyle(.plain)
                } else {
                    TreeOverviewStatusChip(title: item.name, systemImage: "square.stack.3d.up")
                }
            }
        }
    }
}

private struct OverviewChipFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var height: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            height = max(height, y + rowHeight)
        }
        return CGSize(width: maxWidth.isFinite ? maxWidth : x, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
    }
}

struct TreeOverviewPhotosCard: View {
    let imageIDs: [UUID]
    let imageService: ImageService
    var allowsEditing: Bool
    var onSelectImage: (UUID) -> Void
    var onAddPhoto: () -> Void
    var onDropImageFiles: (([ImageDropSource]) -> Void)? = nil
    var onViewAll: (() -> Void)? = nil
    /// When true (equal-height Overview row), card grows with siblings; strip stays top-aligned.
    var fillsRowHeight: Bool = false

    @State private var isDropTargeted = false

    /// Overview strip — same 5:6 portrait as list thumbnails; fixed size (does not stretch).
    private static let thumbWidth: CGFloat = 72
    private static var thumbSize: CGSize { GalleryLayout.portraitSize(width: thumbWidth) }
    /// Fits a 2-column module comfortably; full set remains via View all.
    private static let overviewPhotoLimit = 4

    private var visibleIDs: [UUID] {
        Array(imageIDs.prefix(Self.overviewPhotoLimit))
    }

    var body: some View {
        TreeOverviewModuleCard(
            title: "Photos",
            titleAccessory: onViewAll.map { action in
                AnyView(
                    Button("View all", action: action)
                        .buttonStyle(.borderless)
                        .font(FaloTypography.caption.weight(.medium))
                )
            },
            fillsRowHeight: fillsRowHeight
        ) {
            HStack(alignment: .center, spacing: FaloSpacing.small) {
                ForEach(visibleIDs, id: \.self) { imageID in
                    Button {
                        onSelectImage(imageID)
                    } label: {
                        TreeListThumbnail(
                            imageID: imageID,
                            imageService: imageService,
                            width: Self.thumbSize.width,
                            height: Self.thumbSize.height
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Photo")
                }

                if allowsEditing {
                    addPhotoTile
                } else if imageIDs.isEmpty {
                    Text("No photos yet")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FaloSpacing.xSmall)
            .background {
                if isDropTargeted {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(BonsaiWorldColors.accentSubtle.opacity(0.45))
                }
            }
            .overlay {
                if isDropTargeted {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(BonsaiWorldColors.accent, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                }
            }
            .bonsaiImageFileDrop(
                isEnabled: allowsEditing && onDropImageFiles != nil,
                isTargeted: $isDropTargeted
            ) { urls in
                onDropImageFiles?(urls)
            }
        }
    }

    private var addPhotoTile: some View {
        Button(action: onAddPhoto) {
            VStack(spacing: FaloSpacing.xSmall) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                Text("Add photo")
                    .font(FaloTypography.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(BonsaiWorldColors.textSecondary)
            .frame(width: Self.thumbSize.width, height: Self.thumbSize.height)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .fill(BonsaiWorldColors.accentSubtle.opacity(0.45))
            }
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add photo")
        .help("Add a photo to this tree")
    }
}
