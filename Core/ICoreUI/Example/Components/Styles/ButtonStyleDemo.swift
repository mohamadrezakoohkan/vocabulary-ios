//
//  ButtonStyleDemo.swift
//  ICoreUIExample
//
//  Showcases AppButtonStyle (variant + cornerStyle + isFullWidth).
//

import SwiftUI
import ICoreUI

struct ButtonStyleDemo: View {
    var body: some View {
        DemoScreen(
            title: "ButtonStyle",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var label: String = "Tap me"
    @State private var variantPick: Pickable<ButtonVariant> = ButtonVariant.pickables[0]
    @State private var cornerPick: Pickable<CornerStyle> = CornerStyle.pickables[1]
    @State private var fullWidth: Bool = false
    @State private var isDisabled: Bool = false

    var body: some View {
        InteractiveScroll {
            PreviewSurface(alignment: fullWidth ? .center : .leading) {
                Button(label) { }
                    .buttonStyle(.app(variant: variantPick.value,
                                       cornerStyle: cornerPick.value,
                                       isFullWidth: fullWidth))
                    .disabled(isDisabled)
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Label", text: $label)

                LabeledRow(label: "Variant") {
                    Picker("", selection: $variantPick) {
                        ForEach(ButtonVariant.pickables) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                LabeledRow(label: "Corner") {
                    Picker("", selection: $cornerPick) {
                        ForEach(CornerStyle.pickables) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                Toggle("Full width", isOn: $fullWidth).font(.subheadline)
                Toggle("Disabled",   isOn: $isDisabled).font(.subheadline)
            }
        }
    }

    private var codeSnippet: String {
        let buttonStyleCall = swiftCall(
            ".app",
            arguments: [
                ("variant",     variantPick.code),
                ("cornerStyle", cornerPick.code),
                ("isFullWidth", fullWidth ? "true" : "false"),
            ]
        )

        let suffix = isDisabled ? "\n    .disabled(true)" : ""

        return """
        Button(\(swiftStringLiteral(label))) { }
            .buttonStyle(\(buttonStyleCall))\(suffix)
        """
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Variants — Medium Corners") {
                VStack(spacing: small) {
                    ForEach(ButtonVariant.pickables) { item in
                        Button(item.label.capitalized) { }
                            .buttonStyle(.app(variant: item.value, cornerStyle: .medium))
                    }
                }
            }

            CombinationGroup(title: "Variants — Capsule Corners") {
                VStack(spacing: small) {
                    ForEach(ButtonVariant.pickables) { item in
                        Button(item.label.capitalized) { }
                            .buttonStyle(.app(variant: item.value, cornerStyle: .capsule))
                    }
                }
            }

            CombinationGroup(title: "Corner Styles — Primary Variant") {
                VStack(spacing: small) {
                    ForEach(CornerStyle.pickables) { item in
                        Button(item.label.capitalized) { }
                            .buttonStyle(.app(variant: .primary, cornerStyle: item.value))
                    }
                }
            }

            CombinationGroup(title: "Full Width") {
                VStack(spacing: small) {
                    Button("Primary Full Width") { }
                        .buttonStyle(.app(variant: .primary, isFullWidth: true))
                    Button("Secondary Capsule Full Width") { }
                        .buttonStyle(.app(variant: .secondary, cornerStyle: .capsule, isFullWidth: true))
                    Button("Tertiary Full Width") { }
                        .buttonStyle(.app(variant: .tertiary, isFullWidth: true))
                }
            }

            CombinationGroup(title: "Disabled") {
                VStack(spacing: small) {
                    ForEach(ButtonVariant.pickables) { item in
                        Button(item.label.capitalized) { }
                            .buttonStyle(.app(variant: item.value))
                            .disabled(true)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ButtonStyleDemo() }
}
