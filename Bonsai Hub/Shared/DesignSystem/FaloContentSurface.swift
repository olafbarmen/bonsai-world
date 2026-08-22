//
//  FaloContentSurface.swift
//  Bonsai World
//
//  Reference chrome for scrollable module surfaces.
//  Lists, Forms, and ScrollViews inherit the native window background.
//

import SwiftUI

extension View {
    /// Hides the default opaque scroll fill so content blends with macOS window chrome.
    /// Use on every module `List`, `Form`, and `ScrollView` in the split-view content/detail columns.
    func faloScrollSurface() -> some View {
        scrollContentBackground(.hidden)
    }
}
