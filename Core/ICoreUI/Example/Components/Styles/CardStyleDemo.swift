//
//  CardStyleDemo.swift
//  ICoreUIExample
//
//  Showcases the `.cardStyle(...)` view modifier with all its inputs.
//

import SwiftUI
import ICoreUI

struct CardStyleDemo: View {
    var body: some View {
        DemoScreen(
            title: "CardStyle",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var paddingHorizontal: SpacingChoice = .md
    @State private var paddingVertical: SpacingChoice = .smMd
    @State private var background: NamedColor = .surface
    @State private var hasBorder: Bool = false
    @State private var border: NamedColor = .foregroundMuted
    @State private var borderWidth: CGFloat = 1
    @State private var cornerPick: Pickable<CornerStyle> = CornerStyle.pickables[1]
    @State private var shadow: ShadowChoice = .none

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                CardSample()
                    .cardStyle(
                        paddingHorizontal: paddingHorizontal.value,
                        paddingVertical: paddingVertical.value,
                        backgroundColor: background.color,
                        borderColor: hasBorder ? border.color : nil,
                        borderWidth: borderWidth,
                        cornerStyle: cornerPick.value,
                        shadow: shadow.size
                    )
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                LabeledRow(label: "Padding H") {
                    Picker("", selection: $paddingHorizontal) {
                        ForEach(SpacingChoice.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
                LabeledRow(label: "Padding V") {
                    Picker("", selection: $paddingVertical) {
                        ForEach(SpacingChoice.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
                LabeledRow(label: "Background") {
                    Picker("", selection: $background) {
                        ForEach(NamedColor.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
                Toggle("Has border", isOn: $hasBorder).font(.subheadline)
                if hasBorder {
                    LabeledRow(label: "Border color") {
                        Picker("", selection: $border) {
                            ForEach(NamedColor.allCases) { Text($0.label).tag($0) }
                        }
                        .labelsHidden()
                    }
                    SliderRow(label: "Border width", value: $borderWidth, range: 1...6)
                }
                LabeledRow(label: "Corner style") {
                    Picker("", selection: $cornerPick) {
                        ForEach(CornerStyle.pickables) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
                LabeledRow(label: "Shadow") {
                    Picker("", selection: $shadow) {
                        ForEach(ShadowChoice.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "myView.cardStyle",
            arguments: [
                ("paddingHorizontal", paddingHorizontal.code),
                ("paddingVertical",   paddingVertical.code),
                ("backgroundColor",   background.code),
                ("borderColor",       hasBorder ? border.code : nil),
                ("borderWidth",       hasBorder ? "\(Int(borderWidth))" : nil),
                ("cornerStyle",       cornerPick.code),
                ("shadow",            shadow.code),
            ]
        )
    }
}

private struct CardSample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            Text("Card Title")
                .font(.headline)
            Text("Body copy showing how content sits inside the card.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Backgrounds × Surface") {
                VStack(spacing: small) {
                    sample(label: "surface",        background: .surface,        shadow: .small)
                    sample(label: "primaryRed",     background: .primaryRed,     content: .onRed,    shadow: .medium)
                    sample(label: "primaryBlue",    background: .primaryBlue,    content: .onBlue,   shadow: .medium)
                    sample(label: "primaryYellow",  background: .primaryYellow,  content: .onYellow, shadow: .medium)
                    sample(label: "primaryGreen",   background: .primaryGreen,   content: .onGreen,  shadow: .medium)
                }
            }

            CombinationGroup(title: "Corner Styles") {
                VStack(spacing: small) {
                    ForEach(CornerStyle.pickables) { item in
                        sample(label: ".\(item.label)", background: .surface, corner: item.value, shadow: .small)
                    }
                }
            }

            CombinationGroup(title: "Shadows") {
                VStack(spacing: medium) {
                    ForEach(ShadowChoice.allCases) { item in
                        sample(label: ".\(item.label)", background: .surface, shadow: item.size)
                    }
                }
            }

            CombinationGroup(title: "Borders") {
                VStack(spacing: small) {
                    sample(label: "1pt foreground",    background: .surface, border: .foreground, borderWidth: 1)
                    sample(label: "2pt foreground",    background: .surface, border: .foreground, borderWidth: 2)
                    sample(label: "3pt primaryRed",    background: .surface, border: .primaryRed, borderWidth: 3)
                    sample(label: "4pt primaryBlue",   background: .surface, border: .primaryBlue, borderWidth: 4)
                }
            }
        }
    }

    private func sample(
        label: String,
        background: Color,
        content: Color = .foreground,
        border: Color? = nil,
        borderWidth: CGFloat = 1,
        corner: CornerStyle = .medium,
        shadow: ShadowSize? = .small
    ) -> some View {
        Text(label)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle(
                backgroundColor: background,
                borderColor: border,
                borderWidth: borderWidth,
                cornerStyle: corner,
                shadow: shadow
            )
    }
}

#Preview {
    NavigationStack { CardStyleDemo() }
}
