//
//  BadgeView.swift
//  ICoreUI
//
//  Tinted capsule badge — soft background with matching foreground,
//  following iOS system tag/badge patterns.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Badges use soft tinted backgrounds (color.opacity(0.12)) with matching tinted text.
//  - This is different from ChipView which uses solid filled backgrounds.
//  - Shape is always Capsule — do NOT use rounded rectangles or square corners.
//  - No borders, no shadows, no uppercase text, no letter tracking.
//  - Font is .caption.weight(.medium) — keep it compact and lightweight.
//  - Supports optional leadingIcon, leadingEmoji, and trailingIcon.
//  - BadgeStyle defines contentColor and backgroundColor pairs.
//  - Available styles: .normal, .accent, .info, .success, .danger, .warning.
//  - Previews use native List with sections.
//  - Demo: Core/ICoreUI/Example/Components/Views/BadgeViewDemo.swift
//    Update the Interactive controls and Combinations matrix there
//    whenever the public API or a style is added/removed/renamed.
//

import SwiftUI

public struct BadgeView: View {
    private let label: String
    private let style: BadgeStyle
    private let leadingIcon: Icons?
    private let leadingEmoji: String?
    private let trailingIcon: Icons?

    public init(
        _ label: String,
        style: BadgeStyle = .accent,
        leadingIcon: Icons? = nil,
        trailingIcon: Icons? = nil
    ) {
        self.label = label
        self.style = style
        self.leadingIcon = leadingIcon
        self.leadingEmoji = nil
        self.trailingIcon = trailingIcon
    }

    public init(
        _ label: String,
        emoji: String,
        style: BadgeStyle = .accent
    ) {
        self.label = label
        self.style = style
        self.leadingIcon = nil
        self.leadingEmoji = emoji
        self.trailingIcon = nil
    }

    public var body: some View {
        HStack(spacing: 4) {
            if let emoji = leadingEmoji {
                Text(emoji)
                    .font(.caption2)
            } else if let icon = leadingIcon {
                Icon(icon, size: .small, color: style.contentColor)
            }

            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(style.contentColor)

            if let icon = trailingIcon {
                Icon(icon, size: .small, color: style.contentColor)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(style.backgroundColor)
        .clipShape(Capsule())
    }
}

// MARK: - Preview

private struct BadgePreview: View {
    var body: some View {
        List {
            Section("Styles") {
                HStack(spacing: small) {
                    BadgeView("Normal", style: .normal)
                    BadgeView("Accent", style: .accent)
                    BadgeView("Info", style: .info)
                }
                HStack(spacing: small) {
                    BadgeView("Success", style: .success)
                    BadgeView("Warning", style: .warning)
                    BadgeView("Danger", style: .danger)
                }
            }

            Section("With Icons & Emoji") {
                HStack(spacing: small) {
                    BadgeView("12 Days", emoji: "🔥", style: .warning)
                    BadgeView("Done", style: .success, leadingIcon: .checkmarkCircleFill)
                }
            }
        }
    }
}

#Preview("Light") {
    BadgePreview().preferredColorScheme(.light)
}

#Preview("Dark") {
    BadgePreview().preferredColorScheme(.dark)
}
