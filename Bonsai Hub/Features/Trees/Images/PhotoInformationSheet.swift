//
//  PhotoInformationSheet.swift
//  Bonsai World
//
//  Edit Photo Name, Capture Date, Primary flag, and Delete for one Tree Photo.
//  Delete requests confirmation via the parent Photo Manager (same dialog as
//  the filmstrip context menu). Done only dismisses and commits field edits.
//

import SwiftUI

struct PhotoInformationSheet: View {
    let photoName: Binding<String>
    let captureDate: Binding<Date>
    let isPrimary: Bool
    var onSetPrimary: () -> Void
    var onDelete: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            Text("Photo Information")
                .font(FaloCardTypography.sectionTitle)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(FaloCardTypography.sectionTitleTracking)

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                Text("Photo Name")
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
                TextField("Photo Name", text: photoName)
                    .font(FaloCardTypography.fieldValue)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                Text("Capture Date")
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
                DatePicker(
                    "Capture Date",
                    selection: captureDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.field)
            }

            Divider()

            Toggle(isOn: Binding(
                get: { isPrimary },
                set: { newValue in
                    if newValue { onSetPrimary() }
                }
            )) {
                Text("Primary Photo")
                    .font(FaloCardTypography.fieldValue)
            }
            .toggleStyle(.switch)
            .disabled(isPrimary)

            Spacer(minLength: 0)

            HStack {
                Button("Delete Photo…", role: .destructive) {
                    onDelete()
                }
                Spacer()
                Button("Done") {
                    onDismiss()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(FaloSpacing.xLarge)
        .frame(width: 380, height: 320)
    }
}
