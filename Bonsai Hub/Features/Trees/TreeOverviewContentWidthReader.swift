//
//  TreeOverviewContentWidthReader.swift
//  Bonsai World
//
//  Reads ``faloAdaptiveContentWidth`` inside ``FaloAdaptiveDesktopWorkspace``
//  so Tree Overview column width matches Dashboard’s 4-column math.
//

import SwiftUI

struct TreeOverviewContentWidthReader<Content: View>: View {
    @Environment(\.faloAdaptiveContentWidth) private var contentWidth
    @ViewBuilder var content: (CGFloat) -> Content

    var body: some View {
        content(contentWidth)
    }
}
