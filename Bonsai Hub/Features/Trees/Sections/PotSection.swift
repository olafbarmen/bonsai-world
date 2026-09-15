//
//  PotSection.swift
//  Bonsai World
//
//  Two-layer Pot model on Edit Tree:
//  1. Tree Pot Description — Tree-owned fallback (Pot Type + optional dims)
//  2. Inventory Pot — optional PotService assignment (details owned by Pot module)
//
//  Inventory assignment never erases Tree Pot Description fields.
//

import SwiftUI

struct PotSection: View {
    @Environment(AppSettings.self) private var appSettings

    /// Assigned inventory pot when ``Tree/currentPotID`` resolves; nil = no inventory link.
    var inventoryPot: Pot?
    var inventoryPotDisplayName: String = ""

    @Binding var potTypeID: UUID?
    @Binding var potLengthMillimetres: Int?
    @Binding var potWidthMillimetres: Int?
    @Binding var potHeightMillimetres: Int?
    @Binding var potDiameterMillimetres: Int?

    let potTypes: [DetailPickerOption]
    var isEditing: Bool

    /// Opens Available-pot picker (Assign).
    var onAssignInventoryPot: (() -> Void)? = nil
    /// Opens Available-pot picker to replace current (Change).
    var onChangeInventoryPot: (() -> Void)? = nil
    /// Unlinks via PotService (Remove). Does not delete the Pot.
    var onRemoveInventoryPot: (() -> Void)? = nil
    /// Opens Inventory → Pots focused on the assigned pot.
    var onOpenInventoryPot: (() -> Void)? = nil

    private var system: MeasurementSystem { appSettings.measurementSystem }
    private var hasInventoryPot: Bool { inventoryPot != nil }

    var body: some View {
        DetailCard(title: "Pot") {
            if hasInventoryPot, let pot = inventoryPot {
                inventoryPotBlock(pot)
                Divider().padding(.vertical, FaloSpacing.xSmall)
                treePotDescriptionBlock(isSecondary: true)
            } else {
                treePotDescriptionBlock(isSecondary: false)
                Divider().padding(.vertical, FaloSpacing.xSmall)
                inventoryEmptyBlock
            }
        }
    }

    // MARK: - Inventory Pot (authoritative when assigned)

    @ViewBuilder
    private func inventoryPotBlock(_ pot: Pot) -> some View {
        sectionCaption("Current Inventory Pot")

        if let onOpenInventoryPot {
            Button(action: onOpenInventoryPot) {
                HStack {
                    DetailLabeledRow(label: "Name", value: inventoryPotDisplayName)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        } else {
            DetailLabeledRow(label: "Name", value: inventoryPotDisplayName)
        }
        if !pot.material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DetailLabeledRow(label: "Material", value: pot.material)
        }
        if !pot.shape.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DetailLabeledRow(label: "Shape", value: pot.shape)
        }
        dimensionsBlock(
            length: .constant(pot.lengthMillimetres),
            width: .constant(pot.widthMillimetres),
            height: .constant(pot.heightMillimetres),
            diameter: .constant(pot.diameterMillimetres),
            editable: false
        )

        if isEditing {
            relationshipActions(
                primaryTitle: "Change Pot",
                primaryAction: onChangeInventoryPot,
                secondaryTitle: "Remove Pot",
                secondaryAction: onRemoveInventoryPot,
                secondaryDestructive: true
            )
        }
    }

    @ViewBuilder
    private var inventoryEmptyBlock: some View {
        sectionCaption("Inventory Pot")

        Text("No Inventory Pot assigned")
            .font(FaloTypography.body)
            .foregroundStyle(BonsaiWorldColors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)

        if isEditing, let onAssignInventoryPot {
            Button("Assign Inventory Pot", action: onAssignInventoryPot)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .padding(.top, FaloSpacing.xSmall)
        }
    }

    // MARK: - Tree Pot Description (fallback / always stored)

    @ViewBuilder
    private func treePotDescriptionBlock(isSecondary: Bool) -> some View {
        sectionCaption("Tree Pot Description")

        if isSecondary {
            Text("Used when no Inventory Pot is assigned.")
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, FaloSpacing.xSmall)
        }

        if isEditing {
            DetailOptionPickerRow(
                label: "Pot Type",
                selection: $potTypeID,
                placeholder: "Select Pot Type",
                options: potTypes
            )
            dimensionsBlock(
                length: potLengthMillimetresBinding,
                width: potWidthMillimetresBinding,
                height: potHeightMillimetresBinding,
                diameter: potDiameterMillimetresBinding,
                editable: true
            )
        } else {
            let typeName = DetailOptionPickerRow.displayName(for: potTypeID, in: potTypes)
            DetailLabeledRow(
                label: "Pot Type",
                value: typeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? FaloDisplayValue.empty
                    : typeName
            )
            dimensionsBlock(
                length: .constant(potLengthMillimetres),
                width: .constant(potWidthMillimetres),
                height: .constant(potHeightMillimetres),
                diameter: .constant(potDiameterMillimetres),
                editable: false
            )
        }
    }

    private func sectionCaption(_ title: String) -> some View {
        Text(title)
            .font(FaloTypography.caption.weight(.medium))
            .foregroundStyle(BonsaiWorldColors.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private func relationshipActions(
        primaryTitle: String,
        primaryAction: (() -> Void)?,
        secondaryTitle: String,
        secondaryAction: (() -> Void)?,
        secondaryDestructive: Bool
    ) -> some View {
        HStack(spacing: FaloSpacing.small) {
            if let primaryAction {
                Button(primaryTitle, action: primaryAction)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
            if let secondaryAction {
                Button(secondaryTitle, role: secondaryDestructive ? .destructive : nil, action: secondaryAction)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
            Spacer(minLength: 0)
        }
        .padding(.top, FaloSpacing.xSmall)
    }

    private var potLengthMillimetresBinding: Binding<Int?> {
        Binding(get: { potLengthMillimetres }, set: { potLengthMillimetres = $0 })
    }

    private var potWidthMillimetresBinding: Binding<Int?> {
        Binding(get: { potWidthMillimetres }, set: { potWidthMillimetres = $0 })
    }

    private var potHeightMillimetresBinding: Binding<Int?> {
        Binding(get: { potHeightMillimetres }, set: { potHeightMillimetres = $0 })
    }

    private var potDiameterMillimetresBinding: Binding<Int?> {
        Binding(get: { potDiameterMillimetres }, set: { potDiameterMillimetres = $0 })
    }

    @ViewBuilder
    private func dimensionsBlock(
        length: Binding<Int?>,
        width: Binding<Int?>,
        height: Binding<Int?>,
        diameter: Binding<Int?>,
        editable: Bool
    ) -> some View {
        if editable {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Dimensions")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                dimensionEditRow(title: "Length", dimension: .potLength, value: length)
                dimensionEditRow(title: "Width", dimension: .potWidth, value: width)
                dimensionEditRow(title: "Height", dimension: .potHeight, value: height)
                dimensionEditRow(title: "Diameter", dimension: .potDiameter, value: diameter)
            }
        } else {
            let summary = dimensionsSummary(
                length: length.wrappedValue,
                width: width.wrappedValue,
                height: height.wrappedValue,
                diameter: diameter.wrappedValue
            )
            if !summary.isEmpty {
                DetailLabeledRow(label: "Dimensions", value: summary)
            }
        }
    }

    private func dimensionsSummary(
        length: Int?,
        width: Int?,
        height: Int?,
        diameter: Int?
    ) -> String {
        let segments: [(String, Int?, MeasurementDimension)] = [
            ("L", length, .potLength),
            ("W", width, .potWidth),
            ("H", height, .potHeight),
            ("D", diameter, .potDiameter)
        ]
        let formatted = segments.compactMap { label, millimetres, dimension -> String? in
            guard millimetres != nil else { return nil }
            let value = MeasurementService.string(
                millimetres: millimetres,
                dimension: dimension,
                system: system,
                empty: ""
            )
            guard !value.isEmpty else { return nil }
            return "\(label) \(value)"
        }
        return formatted.joined(separator: " · ")
    }

    @ViewBuilder
    private func dimensionEditRow(
        title: String,
        dimension: MeasurementDimension,
        value: Binding<Int?>
    ) -> some View {
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width

        DetailEditableTextRow(
            label: "\(title) (\(unit))",
            text: Binding(
                get: {
                    MeasurementService.editableNumericString(
                        millimetres: value.wrappedValue,
                        role: role,
                        system: system
                    )
                },
                set: {
                    value.wrappedValue = MeasurementService.millimetres(
                        fromDisplayText: $0,
                        role: role,
                        system: system
                    )
                }
            ),
            help: "Tree Pot Description dimensions. Stored on the Tree in millimetres."
        )
    }
}
