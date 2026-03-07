//
//  ChipStyle.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

/// Defines the visual style of a chip or similar component
public enum ChipStyle {
    /// Default inactive style
    case normal
    /// Active/selected style using accent colors
    case accent
    /// Informational style using info alert colors
    case info
    /// Danger/error style using danger alert colors
    case danger
    /// Warning style using warning alert colors
    case warning
}

// MARK: - Color Resolution

public extension ChipStyle {
    /// Returns the content/foreground color for this style
    func contentColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .normal:
            return theme.content1
        case .accent:
            return theme.accentContent
        case .info:
            return theme.alertInfoContent
        case .danger:
            return theme.alertDangerContent
        case .warning:
            return theme.alertWarningContent
        }
    }
    
    /// Returns the background color for this style
    func backgroundColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .normal:
            return theme.background2
        case .accent:
            return theme.accentBackground
        case .info:
            return theme.alertInfoBackground
        case .danger:
            return theme.alertDangerBackground
        case .warning:
            return theme.alertWarningBackground
        }
    }
    
    /// Returns the border color for this style
    func borderColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .normal:
            return theme.border1
        case .accent:
            return theme.accentBorder
        case .info:
            return theme.alertInfoBorder
        case .danger:
            return theme.alertDangerBorder
        case .warning:
            return theme.alertWarningBorder
        }
    }
}
