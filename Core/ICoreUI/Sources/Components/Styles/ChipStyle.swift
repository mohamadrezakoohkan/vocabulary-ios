//
//  ChipStyle.swift
//  ICoreUI
//
//  Filled chip styles — solid color backgrounds with contrasting text.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Styles/ChipStyleDemo.swift
//    Update the Interactive picker, ChipStyle.pickables in
//    Example/Shared/DemoEnums.swift, and the Combinations gallery
//    there whenever a case is added/removed/renamed.
//

import SwiftUI

public enum ChipStyle {
    /// Neutral — muted fill, foreground text.
    case normal
    /// Accent — red fill, white text.
    case accent
    /// Info — blue fill, white text.
    case info
    /// Success — green fill, white text.
    case success
    /// Danger — red fill, white text.
    case danger
    /// Warning — yellow fill, dark text.
    case warning
}

public extension ChipStyle {
    var contentColor: Color {
        switch self {
        case .normal:          return .foreground
        case .accent, .danger: return .onRed
        case .info:            return .onBlue
        case .success:         return .onGreen
        case .warning:         return .onYellow
        }
    }

    var backgroundColor: Color {
        switch self {
        case .normal:          return Color(.tertiarySystemFill)
        case .accent, .danger: return .primaryRed
        case .info:            return .primaryBlue
        case .success:         return .primaryGreen
        case .warning:         return .primaryYellow
        }
    }
}
