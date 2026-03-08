//
//  BadgeStyle.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

/// The visual style for a badge
public enum BadgeStyle {
    /// Normal style with neutral colors
    case normal
    /// Accent style with primary accent colors
    case accent
    /// Info style with blue tones
    case info
    /// Danger style with red tones
    case danger
    /// Warning style with yellow/orange tones
    case warning
    
    func contentColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            switch self {
            case .normal:
                colorScheme.light.content1
            case .accent:
                colorScheme.light.accentBorder
            case .info:
                colorScheme.light.alertInfoBorder
            case .danger:
                colorScheme.light.alertDangerBorder
            case .warning:
                colorScheme.light.alertWarningBorder
            }
        default:
            switch self {
            case .normal:
                colorScheme.dark.content1
            case .accent:
                colorScheme.dark.accentContent
            case .info:
                colorScheme.dark.alertInfoContent
            case .danger:
                colorScheme.dark.alertDangerContent
            case .warning:
                colorScheme.dark.alertWarningContent
            }
        }
    }
    
    
    func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            switch self {
            case .normal:
                colorScheme.light.background3
            case .accent:
                colorScheme.light.accentBorder.opacity(0.2)
            case .info:
                colorScheme.light.alertInfoBorder.opacity(0.15)
            case .danger:
                colorScheme.light.alertDangerBorder.opacity(0.15)
            case .warning:
                colorScheme.light.alertWarningBorder.opacity(0.2)
            }
        default:
            switch self {
            case .normal:
                colorScheme.dark.background3
            case .accent:
                colorScheme.dark.accentBackground
            case .info:
                colorScheme.dark.alertInfoBackground
            case .danger:
                colorScheme.dark.alertDangerBackground
            case .warning:
                colorScheme.dark.alertWarningBackground
            }
        }
    }
}

private struct BadgeStylePreviewContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: smallMedium) {
            HStack(spacing: small) {
                BadgeView("Normal", style: .normal)
                BadgeView("Accent", style: .accent)
            }

            HStack(spacing: small) {
                BadgeView("Info", style: .info)
                BadgeView("Danger", style: .danger)
                BadgeView("Warning", style: .warning)
            }
        }
    }
}

#Preview("Light Mode") {
    BadgeStylePreviewContent()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    BadgeStylePreviewContent()
        .preferredColorScheme(.dark)
}
