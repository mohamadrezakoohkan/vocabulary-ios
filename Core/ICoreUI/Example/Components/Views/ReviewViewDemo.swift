//
//  ReviewViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct ReviewViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "ReviewView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var badgeText: String = "Planted 23 days ago"
    @State private var badgeEmoji: String = "🌱"
    @State private var quoteText: String = "Friction isn't always bad UX. Sometimes it's a filter for intent."
    @State private var descriptionText: String = "Revisited 2× and evolved into \"Intentional Friction Patterns\"."
    @State private var hasEvolve: Bool = true
    @State private var hasRest: Bool = true
    @State private var hasArchive: Bool = true

    var body: some View {
        InteractiveScroll {
            PreviewSurface(alignment: .leading) {
                ReviewView(
                    badgeText: badgeText,
                    badgeEmoji: badgeEmoji,
                    quoteText: quoteText,
                    descriptionText: descriptionText,
                    onEvolve:  hasEvolve  ? {} : nil,
                    onRest:    hasRest    ? {} : nil,
                    onArchive: hasArchive ? {} : nil
                )
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Badge text", text: $badgeText)
                TextFieldRow(label: "Badge emoji", text: $badgeEmoji)
                TextFieldRow(label: "Quote text", text: $quoteText)
                TextFieldRow(label: "Description", text: $descriptionText)
                Toggle("onEvolve",  isOn: $hasEvolve).font(.subheadline)
                Toggle("onRest",    isOn: $hasRest).font(.subheadline)
                Toggle("onArchive", isOn: $hasArchive).font(.subheadline)
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "ReviewView",
            positional: [],
            arguments: [
                ("badgeText",       swiftStringLiteral(badgeText)),
                ("badgeEmoji",      swiftStringLiteral(badgeEmoji)),
                ("quoteText",       swiftStringLiteral(quoteText)),
                ("descriptionText", swiftStringLiteral(descriptionText)),
                ("onEvolve",        hasEvolve  ? "{ /* evolve */ }" : nil),
                ("onRest",          hasRest    ? "{ /* rest */ }"   : nil),
                ("onArchive",       hasArchive ? "{ /* archive */ }": nil),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Full — All Handlers + Description") {
                ReviewView(
                    badgeText: "Planted 23 days ago",
                    quoteText: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                    descriptionText: "Revisited 2× and evolved into \"Intentional Friction Patterns\".",
                    onEvolve: {}, onRest: {}, onArchive: {}
                )
            }

            CombinationGroup(title: "No description") {
                ReviewView(
                    badgeText: "Surfaced today",
                    badgeEmoji: "✨",
                    quoteText: "Simplicity is the ultimate sophistication.",
                    onEvolve: {}, onRest: {}, onArchive: {}
                )
            }

            CombinationGroup(title: "Only Evolve enabled") {
                ReviewView(
                    badgeText: "Idea seed",
                    badgeEmoji: "💡",
                    quoteText: "Only the Evolve action is enabled here.",
                    descriptionText: "The disabled buttons stay visible at lower opacity to keep the layout stable.",
                    onEvolve: {}
                )
            }

            CombinationGroup(title: "Only Rest enabled") {
                ReviewView(
                    badgeText: "Cooling off",
                    badgeEmoji: "🧊",
                    quoteText: "Some thoughts deserve to rest.",
                    onRest: {}
                )
            }

            CombinationGroup(title: "Only Archive enabled") {
                ReviewView(
                    badgeText: "End of life",
                    badgeEmoji: "📦",
                    quoteText: "Time to archive this one.",
                    onArchive: {}
                )
            }

            CombinationGroup(title: "Read-only (no handlers)") {
                ReviewView(
                    badgeText: "Read-only",
                    badgeEmoji: "🔒",
                    quoteText: "All actions disabled — pure preview.",
                    descriptionText: "Useful for previews, archives, or read-only states."
                )
            }
        }
    }
}

#Preview {
    NavigationStack { ReviewViewDemo() }
}
