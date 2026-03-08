//
//  BadgeView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

/// A reusable badge component for displaying status or metadata
/// Supports different styles and optional leading/trailing icons
public struct BadgeView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    
    /// The text label to display
    private let label: String
    
    /// The visual style of the badge
    private let style: BadgeStyle
    
    /// Optional leading icon
    private let leadingIcon: Icons?
    
    /// Optional leading emoji (takes precedence over leadingIcon)
    private let leadingEmoji: String?
    
    /// Optional trailing icon
    private let trailingIcon: Icons?
    
    /// Whether to use monospaced font
    private let isMonospaced: Bool
    
    // MARK: - Initialization
    
    /// Creates a badge with a label and optional icons
    /// - Parameters:
    ///   - label: The text to display
    ///   - style: The visual style (default: .accent)
    ///   - leadingIcon: Optional icon to display before the label
    ///   - trailingIcon: Optional icon to display after the label
    ///   - isMonospaced: Whether to use monospaced font (default: true)
    public init(
        _ label: String,
        style: BadgeStyle = .accent,
        leadingIcon: Icons? = nil,
        trailingIcon: Icons? = nil,
        isMonospaced: Bool = true
    ) {
        self.label = label
        self.style = style
        self.leadingIcon = leadingIcon
        self.leadingEmoji = nil
        self.trailingIcon = trailingIcon
        self.isMonospaced = isMonospaced
    }
    
    /// Creates a badge with a leading emoji
    /// - Parameters:
    ///   - label: The text to display
    ///   - emoji: The emoji to display before the label
    ///   - style: The visual style (default: .accent)
    ///   - isMonospaced: Whether to use monospaced font (default: true)
    public init(
        _ label: String,
        emoji: String,
        style: BadgeStyle = .accent,
        isMonospaced: Bool = true
    ) {
        self.label = label
        self.style = style
        self.leadingIcon = nil
        self.leadingEmoji = emoji
        self.trailingIcon = nil
        self.isMonospaced = isMonospaced
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: small) {
            if let emoji = leadingEmoji {
                Text(emoji)
            } else if let icon = leadingIcon {
                Icon(icon, size: .small, color: style.contentColor(for: colorScheme))
                    .bold()
            }
            
            Text(label)
                .font(isMonospaced ? .footnote.monospaced() : .footnote)
                .bold()
                .foregroundStyle(style.contentColor(for: colorScheme))

            if let icon = trailingIcon {
                Icon(icon, size: .small, color: style.contentColor(for: colorScheme))
                    .bold()
            }
        }
        .cardStyle(
            paddingHorizontal: 10,
            paddingVertical: 5,
            backgroundColor: style.backgroundColor(for: colorScheme),
            cornerStyle: .rounded(small)
        )
    }
}

// MARK: - Preview

private struct BadgePreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mediumBig) {
                
                // Basic styles
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Styles")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
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
                
                // With icons
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("With Icons")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        BadgeView("Planted 23 days ago", style: .accent, leadingIcon: .clockFill)
                        BadgeView("Active", style: .accent, leadingIcon: .checkmarkCircleFill)
                    }
                    
                    HStack(spacing: small) {
                        BadgeView("3 branches", style: .normal, leadingIcon: .branch)
                        BadgeView("View more", style: .info, trailingIcon: .arrowRight)
                    }
                }
                
                // With emojis
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("With Emojis")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        BadgeView("Planted 23 days ago", emoji: "🌱", style: .accent)
                        BadgeView("Growing", emoji: "🌿", style: .accent)
                    }
                    
                    HStack(spacing: small) {
                        BadgeView("Hot seed", emoji: "🔥", style: .warning)
                        BadgeView("Archived", emoji: "🍂", style: .normal)
                    }
                }
                
                // Status indicators
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Status Indicators")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        BadgeView("Success", style: .accent, leadingIcon: .checkmarkCircleFill)
                        BadgeView("Pending", style: .warning, leadingIcon: .clockFill)
                        BadgeView("Error", style: .danger, leadingIcon: .xmarkCircleFill)
                    }
                }
                
                // Non-monospaced
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Non-Monospaced")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        BadgeView("Regular font", style: .accent, isMonospaced: false)
                        BadgeView("Monospaced", style: .accent, isMonospaced: true)
                    }
                }
            }
            .padding()
        }
        .background(colors.background1)
    }
}

#Preview("Light Mode") {
    BadgePreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    BadgePreview()
        .preferredColorScheme(.dark)
}
