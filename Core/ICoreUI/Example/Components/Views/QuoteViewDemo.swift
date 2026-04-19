//
//  QuoteViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct QuoteViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "QuoteView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var text: String = "Friction isn't always bad UX. Sometimes it's a filter for intent."
    @State private var timestamp: String = "2h ago"
    @State private var branchCount: Int = 3
    @State private var isActive: Bool = true
    @State private var hasOnTap: Bool = true
    @State private var hasOnBranches: Bool = true

    var body: some View {
        InteractiveScroll {
            PreviewSurface(alignment: .leading) {
                QuoteView(
                    text: text,
                    timestamp: timestamp,
                    branchCount: branchCount,
                    isActive: isActive,
                    onTap: hasOnTap ? {} : nil,
                    onBranchesTap: hasOnBranches ? {} : nil
                )
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Text", text: $text)
                TextFieldRow(label: "Timestamp", text: $timestamp)
                StepperRow(label: "Branch count", value: $branchCount, range: 0...99)
                Toggle("Is active",         isOn: $isActive).font(.subheadline)
                Toggle("Has onTap",          isOn: $hasOnTap).font(.subheadline)
                Toggle("Has onBranchesTap",  isOn: $hasOnBranches).font(.subheadline)
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "QuoteView",
            positional: [],
            arguments: [
                ("text",          swiftStringLiteral(text)),
                ("timestamp",     swiftStringLiteral(timestamp)),
                ("branchCount",   "\(branchCount)"),
                ("isActive",      isActive ? "true" : "false"),
                ("onTap",         hasOnTap ? "{ /* tap */ }" : nil),
                ("onBranchesTap", hasOnBranches ? "{ /* branches */ }" : nil),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Active + Branches + Both Handlers") {
                QuoteView(
                    text: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                    timestamp: "2h ago",
                    branchCount: 3,
                    onTap: {},
                    onBranchesTap: {}
                )
            }
            CombinationGroup(title: "Active, no branches") {
                QuoteView(text: "No branches yet — just an idea.",
                          timestamp: "1d ago",
                          branchCount: 0,
                          onTap: {})
            }
            CombinationGroup(title: "Inactive (muted)") {
                QuoteView(text: "Simplicity is the ultimate sophistication.",
                          timestamp: "3d ago",
                          branchCount: 0,
                          isActive: false,
                          onTap: {})
            }
            CombinationGroup(title: "No timestamp, has branches") {
                QuoteView(text: "Timestamp omitted; branches still render.",
                          branchCount: 1,
                          onTap: {},
                          onBranchesTap: {})
            }
            CombinationGroup(title: "Long text + handlers") {
                QuoteView(
                    text: "A long-form quote that wraps onto multiple lines so we can verify body text alignment, leading quote glyph spacing, and the divider above the meta row.",
                    timestamp: "Yesterday",
                    branchCount: 12,
                    onTap: {},
                    onBranchesTap: {}
                )
            }
            CombinationGroup(title: "Static (no onTap)") {
                QuoteView(text: "Static, non-interactive variant.",
                          timestamp: "Just now",
                          branchCount: 4)
            }
            CombinationGroup(title: "Branch pill, non-tappable") {
                QuoteView(text: "Branches show count but pill is static.",
                          timestamp: "1h ago",
                          branchCount: 7,
                          onTap: {})
            }
        }
    }
}

#Preview {
    NavigationStack { QuoteViewDemo() }
}
