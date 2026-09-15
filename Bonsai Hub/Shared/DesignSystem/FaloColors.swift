//
//  FaloColors.swift
//  Bonsai World
//
//  Semantic colour *roles* for Falo application shells.
//  In this product, roles resolve through `BonsaiWorldColors` (World light palette).
//  Hex values live only in BonsaiWorldColors — do not duplicate them here.
//

import SwiftUI

enum FaloColors {
    static var accent: Color { BonsaiWorldColors.accent }

    static var canvas: Color { BonsaiWorldColors.canvas }
    static var surface: Color { BonsaiWorldColors.surface }

    static var textPrimary: Color { BonsaiWorldColors.textPrimary }
    static var textSecondary: Color { BonsaiWorldColors.textSecondary }
    static var textTertiary: Color { BonsaiWorldColors.textTertiary }

    static var border: Color { BonsaiWorldColors.border }
    static var borderSubtle: Color { BonsaiWorldColors.borderSubtle }

    /// Attention / needs care.
    static var statusNeedsAttention: Color { BonsaiWorldColors.statusAttention }
    /// Today / on-track emphasis — uses World accent.
    static var statusToday: Color { BonsaiWorldColors.accent }
    /// Recovering / informational calm.
    static var statusRecovering: Color { BonsaiWorldColors.statusInformation }
}
