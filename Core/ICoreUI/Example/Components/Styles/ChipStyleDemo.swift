//
//  ChipStyleDemo.swift
//  ICoreUIExample
//
//  ChipStyle is a colour pair (`contentColor` + `backgroundColor`)
//  consumed by `ChipView`. The interactive tab lets you pick a style
//  and inspect the resolved colours; the combinations tab renders
//  every style.
//

import SwiftUI
import ICoreUI

struct ChipStyleDemo: View {
    var body: some View {
        DemoScreen(
            title: "ChipStyle",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var style: ChipStyle = .accent
    @State private var sampleText: String = "Chip"

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                ChipView(sampleText, style: style)
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
                        ForEach(ChipStyle.pickables) { Text($0.label).tag($0.value) }
                    }
                    .labelsHidden()
                }
                TextFieldRow(label: "Sample text", text: $sampleText)
            }
        }
    }

    private var codeSnippet: String {
        let label = ChipStyle.pickables.first { $0.value == style }?.label ?? "accent"
        return """
        let style: ChipStyle = .\(label)

        ChipView(\(swiftStringLiteral(sampleText)), style: style)

        // Colors:
        // style.contentColor    → text / icon color
        // style.backgroundColor → solid fill color
        """
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Style → ChipView") {
                VStack(alignment: .leading, spacing: small) {
                    ForEach(ChipStyle.pickables) { item in
                        HStack(spacing: small) {
                            Text(".\(item.label)")
                                .font(.footnote.monospaced())
                                .foregroundStyle(.secondary)
                                .frame(width: 100, alignment: .leading)
                            ChipView(item.label.capitalized, style: item.value)
                            Spacer()
                        }
                    }
                }
            }

            CombinationGroup(title: "Color Pairs") {
                VStack(spacing: small) {
                    ForEach(ChipStyle.pickables) { item in
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

#Preview {
    NavigationStack { ChipStyleDemo() }
}
