//
//  ReviewView.swift
//  ICoreUI
//
//  Apple HIG review card — tinted badge header, editorial quote body,
//  optional description, and a row of tinted icon-label action buttons.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Container: Color.surface, continuous .large corners (16pt), .small soft
//    shadow, NO border. Do NOT add 2-3pt borders or hard offset shadows.
//  - Quote text uses .title3.weight(.semibold) — editorial but not "black".
//    Do NOT wrap the text in literal "..." quotes; use a decorative
//    "quote.opening" SF Symbol (matches QuoteView).
//  - Description uses .subheadline in .foregroundMuted with line spacing.
//  - Header: BadgeView (style .accent) keeps soft tinted look — never swap
//    in a thick-bordered chip here.
//  - Actions: a horizontal row of three tinted icon-over-label buttons
//    (ReviewActionButton). Each uses a soft tinted background (12% of role
//    color), matching role color content (semantic, not Bauhaus-flat):
//      • Evolve  → primaryGreen (growth)
//      • Rest    → primaryBlue  (calm)
//      • Archive → foregroundMuted (neutral)
//    Do NOT use solid filled backgrounds for these in-card actions.
//  - Buttons reserve a 44pt min tap target and animate via spring on press
//    (opacity + small scale). Do NOT animate shadow or border.
//  - When an action handler is nil, render the button disabled (lower
//    opacity, no haptic), do not hide it — keeps the layout stable.
//  - Divider above the action row is a hairline using foregroundMuted at
//    low opacity; do NOT use a solid 1pt foreground line.
//  - Respect Dynamic Type — font sizes are textStyles, never hardcoded.
//  - Accessibility: each action has its own accessibilityLabel; the card
//    itself does not become a button (actions live inside).
//  - Public API is backwards compatible: badgeText, badgeEmoji, quoteText,
//    descriptionText, onEvolve, onRest, onArchive. New options must be
//    additive.
//  - Previews: light + dark, including no-description and missing-handler
//    states to verify disabled visuals.
//  - Demo: Core/ICoreUI/Example/Components/Views/ReviewViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever a new init parameter, action, or disabled state is added.
//

import SwiftUI

public struct ReviewView: View {
    private let badgeText: String
    private let badgeEmoji: String
    private let quoteText: String
    private let descriptionText: String
    private let onEvolve: (() -> Void)?
    private let onRest: (() -> Void)?
    private let onArchive: (() -> Void)?

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

    public var body: some View {
        VStack(alignment: .leading, spacing: medium) {
            BadgeView(badgeText, emoji: badgeEmoji, style: .accent)

            quoteBody

            if !descriptionText.isEmpty {
                Text(descriptionText)
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundMuted)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()
                .overlay(Color.foregroundMuted.opacity(0.15))
                .padding(.top, extraSmall)

            actionsRow
        }
        .cardStyle(
            paddingHorizontal: mediumPlus,
            paddingVertical: mediumPlus,
            backgroundColor: .surface,
            borderColor: nil,
            cornerStyle: .large,
            shadow: .small
        )
    }

    // MARK: - Quote Body

    private var quoteBody: some View {
        HStack(alignment: .top, spacing: small) {
            Image(systemName: "quote.opening")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.primaryBlue.opacity(0.9))
                .padding(.top, 2)
                .accessibilityHidden(true)

            Text(quoteText)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.foreground)
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Actions

    private var actionsRow: some View {
        HStack(spacing: smallMedium) {
            ReviewActionButton(
                icon: .leafFill,
                label: "Evolve",
                tint: .primaryGreen,
                action: onEvolve
            )
            ReviewActionButton(
                icon: .zzz,
                label: "Rest",
                tint: .primaryBlue,
                action: onRest
            )
            ReviewActionButton(
                icon: .tornado,
                label: "Archive",
                tint: .foregroundMuted,
                action: onArchive
            )
        }
    }
}

// MARK: - Review Action Button

private struct ReviewActionButton: View {
    let icon: Icons
    let label: String
    let tint: Color
    let action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: extraSmall + 2) {
                Icon(icon, size: .normal, color: tint)
                Text(label)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(tint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.vertical, small)
            .background(tint.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(ReviewActionButtonStyle())
        .disabled(action == nil)
        .opacity(action == nil ? 0.45 : 1.0)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
    }
}

private struct ReviewActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

// MARK: - Preview

private struct ReviewPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                ReviewView(
                    badgeText: "Planted 23 days ago",
                    quoteText: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                    descriptionText: "Revisited 2× and evolved into \"Intentional Friction Patterns\".",
                    onEvolve: {},
                    onRest: {},
                    onArchive: {}
                )

                ReviewView(
                    badgeText: "Surfaced today",
                    badgeEmoji: "✨",
                    quoteText: "Simplicity is the ultimate sophistication.",
                    onEvolve: {},
                    onRest: {}
                )
            }
            .padding(medium)
        }
        .background(.background)
    }
}

#Preview("Light Mode") {
    ReviewPreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ReviewPreview().preferredColorScheme(.dark)
}
