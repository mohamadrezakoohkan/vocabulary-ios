//
//  BadgeStyle.swift
//  ICoreUI
//
//  Tinted badge styles — soft tinted backgrounds with matching text,
//  similar to iOS system badges and tags.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Styles/BadgeStyleDemo.swift
//    Update the Interactive picker, the .pickables array in
//    Example/Shared/DemoEnums.swift, and the Combinations gallery
//    there whenever a case is added/removed/renamed.
//

import SwiftUI

public enum BadgeStyle {
    case normal
    case accent
    case info
    case success
    case danger
    case warning
}

public extension BadgeStyle {
    var contentColor: Color {
        switch self {
        case .normal:          return .secondary
        case .accent, .danger: return .primaryRed
        case .info:            return .primaryBlue
        case .success:         return .primaryGreen
        case .warning:         return .primaryYellow
        }
    }

    var backgroundColor: Color {
        switch self {
        case .normal:          return Color(.tertiarySystemFill)
        case .accent, .danger: return .primaryRed.opacity(0.12)
        case .info:            return .primaryBlue.opacity(0.12)
        case .success:         return .primaryGreen.opacity(0.12)
        case .warning:         return .primaryYellow.opacity(0.12)
        }
    }
}
