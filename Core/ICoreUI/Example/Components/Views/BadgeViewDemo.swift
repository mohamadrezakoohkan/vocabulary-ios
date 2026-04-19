//
//  BadgeViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct BadgeViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "BadgeView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var label: String = "Badge"
    @State private var style: BadgeStyle = .accent
    @State private var leadingIcon: OptionalIcon = .none
    @State private var trailingIcon: OptionalIcon = .none
    @State private var useEmoji: Bool = false
    @State private var emoji: String = "🔥"

    var body: some View {
        InteractiveScroll {
            PreviewSurface { previewBadge }
            CodeBlock(code: codeSnippet)
            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Label", text: $label)

                LabeledRow(label: "Style") {
                    Picker("", selection: $style) {
                        ForEach(BadgeStyle.pickables) { item in
                            Text(item.label).tag(item.value)
                        }
                    }
                    .labelsHidden()
                }

                Toggle("Use emoji", isOn: $useEmoji)
                    .font(.subheadline)

                if useEmoji {
                    TextFieldRow(label: "Emoji", text: $emoji)
                } else {
                    LabeledRow(label: "Leading icon") {
                        Picker("", selection: $leadingIcon) {
                            ForEach(OptionalIcon.all) { item in
                                Text(item.label).tag(item)
                            }
                        }
                        .labelsHidden()
                    }
                    LabeledRow(label: "Trailing icon") {
                        Picker("", selection: $trailingIcon) {
                            ForEach(OptionalIcon.all) { item in
                                Text(item.label).tag(item)
                            }
                        }
                        .labelsHidden()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var previewBadge: some View {
        if useEmoji {
            BadgeView(label, emoji: emoji, style: style)
        } else {
            BadgeView(
                label,
                style: style,
                leadingIcon: leadingIcon.value,
                trailingIcon: trailingIcon.value
            )
        }
    }

    private var codeSnippet: String {
        if useEmoji {
            return swiftCall(
                "BadgeView",
                positional: [swiftStringLiteral(label)],
                arguments: [
                    ("emoji", swiftStringLiteral(emoji)),
                    ("style", style.code(label: styleLabel)),
                ]
            )
        } else {
            return swiftCall(
                "BadgeView",
                positional: [swiftStringLiteral(label)],
                arguments: [
                    ("style",        style.code(label: styleLabel)),
                    ("leadingIcon",  leadingIcon.code),
                    ("trailingIcon", trailingIcon.code),
                ]
            )
        }
    }

    private var styleLabel: String {
        BadgeStyle.pickables.first { $0.value == style }?.label ?? "accent"
    }
}

private extension BadgeStyle {
    func code(label: String) -> String { ".\(label)" }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "All Styles") {
                wrap {
                    ForEach(BadgeStyle.pickables) { item in
                        BadgeView(item.label.capitalized, style: item.value)
                    }
                }
            }

            CombinationGroup(title: "With Leading Icon") {
                wrap {
                    ForEach(BadgeStyle.pickables) { item in
                        BadgeView(item.label.capitalized,
                                  style: item.value,
                                  leadingIcon: .checkmarkCircleFill)
                    }
                }
            }

            CombinationGroup(title: "With Trailing Icon") {
                wrap {
                    ForEach(BadgeStyle.pickables) { item in
                        BadgeView(item.label.capitalized,
                                  style: item.value,
                                  trailingIcon: .arrowRight)
                    }
                }
            }

            CombinationGroup(title: "With Both Icons") {
                wrap {
                    ForEach(BadgeStyle.pickables) { item in
                        BadgeView(item.label.capitalized,
                                  style: item.value,
                                  leadingIcon: .star,
                                  trailingIcon: .chevronRight)
                    }
                }
            }

            CombinationGroup(title: "With Emoji") {
                wrap {
                    BadgeView("Hot",     emoji: "🔥", style: .warning)
                    BadgeView("Saved",   emoji: "💾", style: .info)
                    BadgeView("Done",    emoji: "✅", style: .success)
                    BadgeView("Failed",  emoji: "⚠️", style: .danger)
                    BadgeView("Sprout",  emoji: "🌱", style: .accent)
                    BadgeView("Default", emoji: "🏷️", style: .normal)
                }
            }
        }
    }

    private func wrap<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        DemoFlowLayout(spacing: small) { content() }
    }
}

#Preview {
    NavigationStack { BadgeViewDemo() }
}
