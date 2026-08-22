//
//  SidebarSectionHeader.swift
//  Bonsai World
//
//  Level 1 sidebar labels — Workspace / Quick Actions / Tools.
//  Quiet group separators; not navigable.
//

import SwiftUI

struct SidebarSectionHeader: View {
    let title: String
    /// Extra space above the label — use between major sidebar groups.
    var topPadding: CGFloat = 0

    var body: some View {
        Text(title)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(.secondary.opacity(0.85))
            .textCase(.uppercase)
            .tracking(1.1)
            .padding(.top, topPadding)
            .padding(.bottom, FaloSpacing.xSmall)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    List {
        Section {
            Text("Item")
        } header: {
            SidebarSectionHeader(title: "Workspace")
        }
    }
    .listStyle(.sidebar)
    .frame(width: 220)
}
