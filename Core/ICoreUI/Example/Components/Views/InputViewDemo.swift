//
//  InputViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct InputViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "InputView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var text: String = ""
    @State private var placeholder: String = "Write your thought…"
    @State private var minHeight: CGFloat = 120
    @State private var maxHeight: CGFloat = 500
    @State private var useMaxLength: Bool = false
    @State private var maxLength: Int = 100
    @State private var accentColor: NamedColor = .primaryBlue
    @State private var showsClearButton: Bool = true

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                InputView(
                    text: $text,
                    placeholder: placeholder,
                    minHeight: minHeight,
                    maxHeight: maxHeight,
                    maxLength: useMaxLength ? maxLength : nil,
                    accentColor: accentColor.color,
                    showsClearButton: showsClearButton
                )
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Placeholder", text: $placeholder)
                SliderRow(label: "Min height", value: $minHeight, range: 60...300)
                SliderRow(label: "Max height", value: $maxHeight, range: 100...700)

                Toggle("Use max length", isOn: $useMaxLength).font(.subheadline)
                if useMaxLength {
                    StepperRow(label: "Max length", value: $maxLength, range: 10...500)
                }

                LabeledRow(label: "Accent color") {
                    Picker("", selection: $accentColor) {
                        ForEach(NamedColor.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                Toggle("Shows clear button", isOn: $showsClearButton).font(.subheadline)
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "InputView",
            positional: [],
            arguments: [
                ("text",             "$text"),
                ("placeholder",      swiftStringLiteral(placeholder)),
                ("minHeight",        "\(Int(minHeight))"),
                ("maxHeight",        "\(Int(maxHeight))"),
                ("maxLength",        useMaxLength ? "\(maxLength)" : nil),
                ("accentColor",      accentColor.code),
                ("showsClearButton", showsClearButton ? "true" : "false"),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    @State private var empty = ""
    @State private var typed = "Typed content example."
    @State private var counted = "Almost at the limit of this short input field."
    @State private var redText = ""
    @State private var greenText = "Green accent variant"
    @State private var noClear = "Cannot clear"
    @State private var compact = ""
    @State private var tall = ""

    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Default") {
                InputView(text: $empty, placeholder: "Default empty state")
            }
            CombinationGroup(title: "Pre-filled") {
                InputView(text: $typed, placeholder: "Pre-filled text")
            }
            CombinationGroup(title: "With character counter") {
                InputView(text: $counted,
                          placeholder: "Max 60 characters",
                          minHeight: 80,
                          maxLength: 60)
            }
            CombinationGroup(title: "Red accent") {
                InputView(text: $redText,
                          placeholder: "Red accent",
                          accentColor: .primaryRed)
            }
            CombinationGroup(title: "Green accent") {
                InputView(text: $greenText,
                          placeholder: "Green accent",
                          accentColor: .primaryGreen)
            }
            CombinationGroup(title: "Without clear button") {
                InputView(text: $noClear,
                          placeholder: "No clear button",
                          showsClearButton: false)
            }
            CombinationGroup(title: "Compact (60pt)") {
                InputView(text: $compact,
                          placeholder: "Compact 60pt min",
                          minHeight: 60,
                          maxHeight: 120)
            }
            CombinationGroup(title: "Tall (200pt)") {
                InputView(text: $tall,
                          placeholder: "Tall 200pt min",
                          minHeight: 200,
                          maxHeight: 400)
            }
        }
    }
}

#Preview {
    NavigationStack { InputViewDemo() }
}
