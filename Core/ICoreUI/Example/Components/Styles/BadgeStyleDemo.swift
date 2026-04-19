//
//  BadgeStyleDemo.swift
//  ICoreUIExample
//
//  BadgeStyle is a colour pair (`contentColor` + `backgroundColor`)
//  consumed by `BadgeView`. The interactive tab lets you pick a style
//  and see both colours applied to a sample BadgeView; the
//  combinations tab renders every style.
//

import SwiftUI
import ICoreUI

struct BadgeStyleDemo: View {
    var body: some View {
        DemoScreen(
            title: "BadgeStyle",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var style: BadgeStyle = .accent
    @State private var sampleText: String = "Badge"

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                BadgeView(sampleText, style: style)
            }

            ColorSwatchRow(
                title: "Resolved Colors",
                pairs: [
                    ("contentColor",    style.contentColor),
                    ("backgroundColor", style.backgroundColor),
                ]
            )

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                LabeledRow(label: "Style") {
                    Picker("", selection: $style) {
                        ForEach(BadgeStyle.pickables) { Text($0.label).tag($0.value) }
                    }
                    .labelsHidden()
                }
                TextFieldRow(label: "Sample text", text: $sampleText)
            }
        }
    }

    private var codeSnippet: String {
        let label = BadgeStyle.pickables.first { $0.value == style }?.label ?? "accent"
        return """
        let style: BadgeStyle = .\(label)

        BadgeView(\(swiftStringLiteral(sampleText)), style: style)

        // Colors:
        // style.contentColor    → tinted text
        // style.backgroundColor → tinted background
        """
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Style → BadgeView") {
                VStack(alignment: .leading, spacing: small) {
                    ForEach(BadgeStyle.pickables) { item in
                        HStack(spacing: small) {
                            Text(".\(item.label)")
                                .font(.footnote.monospaced())
                                .foregroundStyle(.secondary)
                                .frame(width: 100, alignment: .leading)
                            BadgeView(item.label.capitalized, style: item.value)
                            Spacer()
                        }
                    }
                }
            }

            CombinationGroup(title: "Color Pairs") {
                VStack(spacing: small) {
                    ForEach(BadgeStyle.pickables) { item in
                        HStack(spacing: small) {
                            Text(".\(item.label)")
                                .font(.footnote.monospaced())
                                .frame(width: 100, alignment: .leading)
                            colorChip(item.value.backgroundColor, label: "bg")
                            colorChip(item.value.contentColor,    label: "fg")
                            Spacer()
                        }
                    }
                }
            }
        }
    }

    private func colorChip(_ color: Color, label: String) -> some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 36, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.foregroundMuted.opacity(0.2), lineWidth: 1)
                )
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Color Swatch Row

struct ColorSwatchRow: View {
    let title: String
    let pairs: [(String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.foregroundMuted)

            HStack(spacing: small) {
                ForEach(Array(pairs.enumerated()), id: \.offset) { _, pair in
                    HStack(spacing: small) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(pair.1)
                            .frame(width: 32, height: 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.foregroundMuted.opacity(0.2), lineWidth: 1)
                            )
                        Text(pair.0)
                            .font(.caption.monospaced())
                    }
                }
                Spacer()
            }
            .padding(small)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.foregroundMuted.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack { BadgeStyleDemo() }
}
