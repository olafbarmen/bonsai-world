//
//  MobileAppMenuView.swift
//  Bonsai World
//
//  Navigation environment keys for tab-based mobile root.
//  Menu sheet retired in favor of Trees · Tasks · More.
//

import SwiftUI

private struct AppendMobileRouteKey: EnvironmentKey {
    static let defaultValue: (MobileRoute) -> Void = { _ in }
}

private struct OpenMobileTreeKey: EnvironmentKey {
    static let defaultValue: (UUID) -> Void = { _ in }
}

extension EnvironmentValues {
    var appendMobileRoute: (MobileRoute) -> Void {
        get { self[AppendMobileRouteKey.self] }
        set { self[AppendMobileRouteKey.self] = newValue }
    }

    /// Switches to the Trees tab and opens the tree (G1).
    var openMobileTree: (UUID) -> Void {
        get { self[OpenMobileTreeKey.self] }
        set { self[OpenMobileTreeKey.self] = newValue }
    }
}
