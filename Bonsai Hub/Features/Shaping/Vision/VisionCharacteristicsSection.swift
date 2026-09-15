//
//  VisionCharacteristicsSection.swift
//  Bonsai World
//
//  Key Characteristics for Shaping → Vision — Trunk / Branch / Apex / Nebari + extras.
//

import SwiftUI

struct VisionCharacteristicsSection: View {
    @Binding var trunk: VisionCharacteristicSlot
    @Binding var branch: VisionCharacteristicSlot
    @Binding var apex: VisionCharacteristicSlot
    @Binding var nebari: VisionCharacteristicSlot
    @Binding var additionalCharacteristics: [VisionCharacteristic]

    var body: some View {
        DetailCard(title: "Key Characteristics") {
            Text("Things I want to preserve, develop or change.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                fixedCharacteristicRow(title: VisionFixedCharacteristic.trunk.title, slot: $trunk)
                fixedCharacteristicRow(title: VisionFixedCharacteristic.branch.title, slot: $branch)
                fixedCharacteristicRow(title: VisionFixedCharacteristic.apex.title, slot: $apex)
                fixedCharacteristicRow(title: VisionFixedCharacteristic.nebari.title, slot: $nebari)

                if !additionalCharacteristics.isEmpty {
                    ForEach($additionalCharacteristics) { $characteristic in
                        additionalCharacteristicRow(
                            characteristic: $characteristic,
                            onDelete: { removeAdditional(id: characteristic.id) }
                        )
                    }
                }
            }
            .padding(.top, FaloSpacing.small)

            Button {
                addAdditionalCharacteristic()
            } label: {
                Label("Add Characteristic", systemImage: "plus")
            }
            .buttonStyle(.bordered)
            .padding(.top, FaloSpacing.small)
            .accessibilityLabel("Add Characteristic")
        }
    }

    private func fixedCharacteristicRow(title: String, slot: Binding<VisionCharacteristicSlot>) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            characteristicTypePicker(
                kind: Binding(
                    get: { slot.wrappedValue.kind },
                    set: { newKind in
                        var updated = slot.wrappedValue
                        updated.kind = newKind
                        slot.wrappedValue = updated
                    }
                )
            )
            VisionNoteField(
                text: Binding(
                    get: { slot.wrappedValue.text },
                    set: { newText in
                        var updated = slot.wrappedValue
                        updated.text = newText
                        slot.wrappedValue = updated
                    }
                )
            )
        }
    }

    private func additionalCharacteristicRow(
        characteristic: Binding<VisionCharacteristic>,
        onDelete: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack(alignment: .top, spacing: FaloSpacing.small) {
                characteristicTypePicker(kind: characteristic.kind)
                Spacer(minLength: FaloSpacing.small)
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                }
                .buttonStyle(.borderless)
                .help("Remove characteristic")
                .accessibilityLabel("Remove characteristic")
            }
            VisionNoteField(text: characteristic.text)
        }
    }

    private func characteristicTypePicker(kind: Binding<VisionCharacteristicKind>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Type")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Picker("Type", selection: kind) {
                ForEach(VisionCharacteristicKind.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .font(FaloCardTypography.fieldValue)
            .fontWeight(.regular)
        }
    }

    private func addAdditionalCharacteristic() {
        additionalCharacteristics.append(VisionCharacteristic())
    }

    private func removeAdditional(id: UUID) {
        additionalCharacteristics.removeAll { $0.id == id }
    }
}

/// White note field — matches Vision Statement and Notes styling.
private struct VisionNoteField: View {
    @Binding var text: String

    var body: some View {
        TextEditor(text: $text)
            .font(FaloCardTypography.fieldValue)
            .fontWeight(.regular)
            .foregroundStyle(.primary)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 56, alignment: .topLeading)
            .padding(FaloSpacing.small)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .fill(Color(nsColor: .textBackgroundColor))
            }
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
    }
}
