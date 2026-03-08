//
//  ReviewView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI
/// A card component for revisiting seeds
/// Displays a badge, quote, description text, and action buttons (Evolve, Rest, Archive)
public struct ReviewView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    // MARK: - Properties
    
    /// The badge text (e.g., "Planted 23 days ago")
    private let badgeText: String
    
    /// The badge emoji
    private let badgeEmoji: String
    
    /// The main quote text
    private let quoteText: String
    
    /// The description text below the quote
    private let descriptionText: String
    
    /// Action when Evolve button is tapped
    private let onEvolve: (() -> Void)?
    
    /// Action when Rest button is tapped
    private let onRest: (() -> Void)?
    
    /// Action when Archive button is tapped
    private let onArchive: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a revisit card
    /// - Parameters:
    ///   - badgeText: The badge text (e.g., "Planted 23 days ago")
    ///   - badgeEmoji: The badge emoji
    ///   - quoteText: The main quote text
    ///   - descriptionText: The description text below the quote
    ///   - onEvolve: Action when Evolve button is tapped
    ///   - onRest: Action when Rest button is tapped
    ///   - onArchive: Action when Archive button is tapped
    public init(
        badgeText: String,
        badgeEmoji: String = "🌱",
        quoteText: String,
        descriptionText: String = "",
        onEvolve: (() -> Void)? = nil,
        onRest: (() -> Void)? = nil,
        onArchive: (() -> Void)? = nil
    ) {
        self.badgeText = badgeText
        self.badgeEmoji = badgeEmoji
        self.quoteText = quoteText
        self.descriptionText = descriptionText
        self.onEvolve = onEvolve
        self.onRest = onRest
        self.onArchive = onArchive
    }
    
    // MARK: - Body

    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: medium) {
                // Badge
                BadgeView(badgeText, emoji: badgeEmoji, style: .accent)

                // Quote text
                Text("\"\(quoteText)\"")
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(colors.content1)
                    .multilineTextAlignment(.leading)

                // Description text
                if !descriptionText.isEmpty {
                    Text(descriptionText)
                        .font(.subheadline)
                        .foregroundStyle(colors.content2)
                        .multilineTextAlignment(.leading)
                }

                // Action buttons
                HStack(spacing: smallMedium) {
                    actionButton(
                        icon: .leafFill,
                        label: "Evolve",
                        iconColor: colors.accentContent,
                        variant: .accent,
                        action: onEvolve
                    )

                    actionButton(
                        icon: .zzz,
                        label: "Rest",
                        iconColor: colors.alertWarningContent,
                        variant: .warning,
                        action: onRest
                    )

                    actionButton(
                        icon: .tornado,
                        label: "Archive",
                        iconColor: colors.alertDangerContent,
                        variant: .danger,
                        action: onArchive
                    )
                }
                .frame(maxWidth: .infinity)
            }
            .cardStyle(
                paddingHorizontal: mediumBig,
                paddingVertical: mediumBig,
                backgroundColor: colors.background2,
                borderColor: colors.border1,
                cornerStyle: CornerStyle.rounded(12)
            )
            RoundedRectangle(cornerRadius: medium)
                .stroke(colors.accentPrimary, lineWidth: 5)
                .mask(
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 3)
                        Spacer()
                    }
                )
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private func actionButton(
        icon: Icons,
        label: String,
        iconColor: Color,
        variant: ButtonVariant,
        action: (() -> Void)?
    ) -> some View {
        Button {
            action?()
        } label: {
            GeometryReader { proxy in
                VStack(spacing: small) {
                    Icon(icon, size: .large, color: iconColor)
                    Text(label)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.app(variant: variant))
        .aspectRatio(1, contentMode: .fill)
    }
}

// MARK: - Preview

private struct RevisitPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                
                // Example from the screenshot
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Screenshot Example")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    ReviewView(
                        badgeText: "Planted 23 days ago",
                        quoteText: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                        descriptionText: "This seed has been revisited 2× and evolved once into \"Intentional Friction Patterns\""
                    )
                }
                
                // Without description
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Without Description")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    ReviewView(
                        badgeText: "Planted 5 days ago",
                        quoteText: "The best code is no code at all."
                    )
                }
                
                // With custom emoji
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Custom Emoji")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    ReviewView(
                        badgeText: "Growing strong",
                        badgeEmoji: "🌿",
                        quoteText: "Design is not just what it looks like. Design is how it works.",
                        descriptionText: "Evolved from initial thoughts on product design"
                    )
                }
                
                // Interactive example
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    InteractiveRevisitDemo()
                }
            }
            .padding()
        }
        .background(colors.background1)
    }
}

// MARK: - Interactive Demo

private struct InteractiveRevisitDemo: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var lastAction: String = ""
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: smallMedium) {
            ReviewView(
                badgeText: "Planted 10 days ago",
                quoteText: "Every good design begins with an even better story.",
                descriptionText: "Ready for evolution",
                onEvolve: {
                    lastAction = "Evolve tapped"
                },
                onRest: {
                    lastAction = "Rest tapped"
                },
                onArchive: {
                    lastAction = "Archive tapped"
                }
            )
            
            if !lastAction.isEmpty {
                Text(lastAction)
                    .font(.subheadline)
                    .foregroundStyle(colors.accentSecondary)
            }
        }
    }
}

#Preview("Light Mode") {
    RevisitPreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    RevisitPreview()
        .preferredColorScheme(.dark)
}

