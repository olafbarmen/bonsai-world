//
//  MobileRootView.swift
//  Bonsai World
//

import SwiftUI

struct MobileRootView: View {
    var body: some View {
        NavigationStack {
            TreeListView()
                .navigationTitle("Bonsai World")
        }
    }
}

#Preview {
    MobileRootView()
        .environment(DemoLibrary())
}
