//
//  ChipViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct ChipViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "ChipView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private enum ChipMode: String, CaseIterable, Identifiable {
    case display = "Display"
    case interactive = "Interactive"
    var id: String { rawValue }
}

private struct Interactive: View {
    @State private var label: String = "Filter"
    @State private var mode: ChipMode = .display
    // display
    @State private var style: ChipStyle = .normal
    @State private var leadingIcon: OptionalIcon = .none
    @State private var trailingIcon: OptionalIcon = .none
    // interactive
    @State private var isActive: Bool = false
    @State private var showChevron: Bool = false

    var body: some View {
        InteractiveScroll {
            PreviewSurface { previewChip }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Label", text: $label)

                LabeledRow(label: "Mode") {
                    Picker("", selection: $mode) {
                        ForEach(ChipMode.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .labelsHidden()
                }

                if mode == .display {
                    LabeledRow(label: "Style") {
                        Picker("", selection: $style) {
                            ForEach(ChipStyle.pickables) { item in
                                Text(item.label).tag(item.value)
                            }
                        }
                        .labelsHidden()
                    }
                    LabeledRow(label: "Leading icon") {
                        Picker("", selection: $leadingIcon) {
                            ForEach(OptionalIcon.all) { Text($0.label).tag($0) }
                        }
                        .labelsHidden()
                    }
                    LabeledRow(label: "Trailing icon") {
                        Picker("", selection: $trailingIcon) {
                            ForEach(OptionalIcon.all) { Text($0.label).tag($0) }
                        }
                        .labelsHidden()
                    }
                } else {
                    Toggle("Is active",   isOn: $isActive).font(.subheadline)
                    Toggle("Show chevron", isOn: $showChevron).font(.subheadline)
                }
            }
        }
    }

    @ViewBuilder
    private var previewChip: some View {
        switch mode {
        case .display:
            ChipView(label,
                     style: style,
                     leadingIcon: leadingIcon.value,
                     trailingIcon: trailingIcon.value)
        case .interactive:
            ChipView(label,
                     isActive: isActive,
                     showChevron: showChevron) {
                isActive.toggle()
            }
        }
    }

    private var codeSnippet: String {
        switch mode {
        case .display:
            let styleLabel = ChipStyle.pickables.first { $0.value == style }?.label ?? "normal"
            return swiftCall(
                "ChipView",
                positional: [swiftStringLiteral(label)],
                arguments: [
                    ("style",        ".\(styleLabel)"),
                    ("leadingIcon",  leadingIcon.code),
                    ("trailingIcon", trailingIcon.code),
                ]
            )
        case .interactive:
            return swiftCall(
                "ChipView",
                positional: [swiftStringLiteral(label)],
                arguments: [
                    ("isActive",    isActive ? "true" : "false"),
                    ("showChevron", showChevron ? "true" : "false"),
                    ("action",      "{ /* toggle */ }"),
                ]
            )
        }
    }
}

// MARK: - Combinations

private struct Combinations: View {
    @State private var active = false

    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "All Display Styles") {
                DemoFlowLayout(spacing: small) {
                    ForEach(ChipStyle.pickables) { item in
                        ChipView(item.label.capitalized, style: item.value)
                    }
                }
            }

            CombinationGroup(title: "Display + Leading Icon") {
                DemoFlowLayout(spacing: small) {
                    ForEach(ChipStyle.pickables) { item in
                        ChipView(item.label.capitalized,
                                 style: item.value,
                                 leadingIcon: .checkmarkCircleFill)
                    }
                }
            }

            CombinationGroup(title: "Display + Trailing Icon") {
                DemoFlowLayout(spacing: small) {
                    ForEach(ChipStyle.pickables) { item in
                        ChipView(item.label.capitalized,
                                 style: item.value,
                                 trailingIcon: .arrowRight)
                    }
                }
            }

            CombinationGroup(title: "Interactive") {
                DemoFlowLayout(spacing: small) {
                    ChipView("Tap me", isActive: active) { active.toggle() }
                    ChipView("Inactive", isActive: false, showChevron: true)
                    ChipView("Active",   isActive: true,  showChevron: true)
                    ChipView("With chevron", isActive: false, showChevron: true) { }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ChipViewDemo() }
}
