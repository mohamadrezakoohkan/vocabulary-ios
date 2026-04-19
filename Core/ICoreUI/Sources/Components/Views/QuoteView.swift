//
//  QuoteView.swift
//  ICoreUI
//
//  Apple HIG quote card — surface background, no hard border, soft shadow,
//  decorative quote glyph, sentence-cased meta row with a tinted branch pill.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Container: Color.surface, continuous .medium corners (12pt), .small soft
//    shadow. Do NOT add 2-3pt borders or hard offset shadows.
//  - Use a subtle decorative SF Symbol ("quote.opening") in .primaryBlue for
//    visual hierarchy — never wrap the body text in literal "" quotes.
//  - Body text uses .body and ALWAYS supports Dynamic Type. The inactive
//    state shifts color to .foregroundMuted only — never hide content.
//  - Meta row (timestamp + branches) is separated by a hairline Divider, not
//    a thick border. Typography is .footnote / .caption — sentence case, no
//    UPPERCASE, no .tracking(), no .monospaced(). Monospaced digits are OK
//    for the branch count to keep alignment.
//  - Branch affordance is a tinted info pill (BadgeStyle.info colors) — do
//    NOT inline as plain underlined text. It is a Button when onBranchesTap
//    is provided, otherwise rendered as a static badge.
//  - The whole card is tappable when onTap is provided; use the custom
//    QuoteButtonStyle for press feedback (opacity + small scale, spring
//    animation). Do NOT animate via shadow toggling — it causes layout jitter.
//  - The branches button must NOT propagate the parent tap; isolate it with
//    its own Button + .buttonStyle and rely on hit-test ordering.
//  - When onTap is nil, render as a non-interactive container (no Button).
//  - Public API is backwards compatible: text, timestamp, branchCount,
//    isActive, onTap, onBranchesTap. New options must be additive.
//  - Accessibility: combine children into a single element with a clear
//    label ("<text>, <timestamp>, <n> branches"); the branch pill stays an
//    independent accessible action when tappable.
//  - Previews: light + dark, covering active / inactive / no-branches states.
//  - Demo: Core/ICoreUI/Example/Components/Views/QuoteViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever the public API or a meta-row state changes.
//

import SwiftUI

public struct QuoteView: View {
    private let text: String
    private let timestamp: String
    private let branchCount: Int
    private let isActive: Bool
    private let onTap: (() -> Void)?
    private let onBranchesTap: (() -> Void)?

    public init(
        text: String,
        timestamp: String = "",
        branchCount: Int = 0,
        isActive: Bool = true,
        onTap: (() -> Void)? = nil,
        onBranchesTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.timestamp = timestamp
        self.branchCount = branchCount
        self.isActive = isActive
        self.onTap = onTap
        self.onBranchesTap = onBranchesTap
    }

    public var body: some View {
        if let onTap {
            Button(action: onTap) { card }
                .buttonStyle(QuoteButtonStyle())
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityLabel)
                .accessibilityAddTraits(.isButton)
        } else {
            card
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityLabel)
        }
    }

    // MARK: - Card

    private var card: some View {
        VStack(alignment: .leading, spacing: smallMedium) {
            quoteBody

            if hasMetaRow {
                Divider()
                    .overlay(Color.foregroundMuted.opacity(0.15))
                metaRow
            }
        }
        .cardStyle(
            paddingHorizontal: medium,
            paddingVertical: medium,
            backgroundColor: .surface,
            borderColor: nil,
            cornerStyle: .medium,
            shadow: .small
        )
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var quoteBody: some View {
        HStack(alignment: .top, spacing: small) {
            Image(systemName: "quote.opening")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.primaryBlue.opacity(isActive ? 0.9 : 0.5))
                .padding(.top, 2)
                .accessibilityHidden(true)

            Text(text)
                .font(.body)
                .foregroundStyle(isActive ? Color.foreground : Color.foregroundMuted)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var metaRow: some View {
        HStack(alignment: .center, spacing: small) {
            if !timestamp.isEmpty {
                Text(timestamp)
                    .font(.footnote)
                    .foregroundStyle(Color.foregroundMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            if branchCount > 0 {
                branchPill
            }
        }
    }

    @ViewBuilder
    private var branchPill: some View {
        let label = branchPillLabel
        if let onBranchesTap {
            Button(action: onBranchesTap) {
                branchPillContent(label: label)
            }
            .buttonStyle(BranchPillButtonStyle())
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isButton)
        } else {
            branchPillContent(label: label)
                .accessibilityLabel(label)
        }
    }

    private func branchPillContent(label: String) -> some View {
        HStack(spacing: extraSmall) {
            Image(systemName: "arrow.trianglehead.branch")
                .font(.caption.weight(.semibold))
            Text("\(branchCount)")
                .font(.caption.weight(.semibold).monospacedDigit())
        }
        .foregroundStyle(Color.primaryBlue)
        .padding(.horizontal, smallMedium)
        .padding(.vertical, extraSmall + 1)
        .background(Color.primaryBlue.opacity(0.12))
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
    }

    // MARK: - Helpers

    private var hasMetaRow: Bool {
        !timestamp.isEmpty || branchCount > 0
    }

    private var branchPillLabel: String {
        "\(branchCount) \(branchCount == 1 ? "branch" : "branches")"
    }

    private var accessibilityLabel: String {
        var parts: [String] = [text]
        if !timestamp.isEmpty { parts.append(timestamp) }
        if branchCount > 0 { parts.append(branchPillLabel) }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Button Styles

private struct QuoteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.85), value: configuration.isPressed)
    }
}

private struct BranchPillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

// MARK: - Preview

private struct QuotePreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                QuoteView(
                    text: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                    timestamp: "2h ago",
                    branchCount: 3,
                    onTap: {},
                    onBranchesTap: {}
                )
                QuoteView(
                    text: "Simplicity is the ultimate sophistication.",
                    timestamp: "3d ago",
                    branchCount: 0,
                    isActive: false,
                    onTap: {}
                )
                QuoteView(
                    text: "A long-form quote that wraps onto multiple lines so we can verify body text alignment, leading quote glyph spacing, and the divider above the meta row.",
                    timestamp: "Yesterday",
                    branchCount: 1,
                    onTap: {},
                    onBranchesTap: {}
                )
                QuoteView(
                    text: "No timestamp, no branches — just the quote.",
                    onTap: {}
                )
            }
            .padding(medium)
        }
        .background(.background)
    }
}

#Preview("Light Mode") {
    QuotePreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    QuotePreview().preferredColorScheme(.dark)
}
