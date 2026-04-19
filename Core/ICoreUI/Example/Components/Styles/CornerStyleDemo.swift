//
//  CornerStyleDemo.swift
//  ICoreUIExample
//
//  CornerStyle drives `clipCornerStyle(_:)` and is consumed by both
//  `CardStyle` and `AppButtonStyle`. The interactive tab lets you
//  pick a value (with a custom radius slider) and see the resulting
//  shape; the combinations tab shows every preset side-by-side.
//

import SwiftUI
import ICoreUI

struct CornerStyleDemo: View {
    var body: some View {
        DemoScreen(
            title: "CornerStyle",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Preset choices (we flatten `.custom` so the picker is finite)

private enum CornerChoice: String, CaseIterable, Identifiable {
    case small, medium, large, capsule, custom

    var id: String { rawValue }
    var label: String { rawValue }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var choice: CornerChoice = .medium
    @State private var customRadius: CGFloat = 24

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                ShapePreview()
                    .clipCornerStyle(currentStyle)
                    .frame(width: 220, height: 120)
            }

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                LabeledRow(label: "Style") {
                    Picker("", selection: $choice) {
                        ForEach(CornerChoice.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }
                if choice == .custom {
                    SliderRow(label: "Custom radius", value: $customRadius, range: 0...100)
                }
            }
        }
    }

    private var currentStyle: CornerStyle {
        switch choice {
        case .small:   return .small
        case .medium:  return .medium
        case .large:   return .large
        case .capsule: return .capsule
        case .custom:  return .custom(customRadius)
        }
    }

    private var codeSnippet: String {
        let styleString: String = {
            switch choice {
            case .small, .medium, .large, .capsule:
                return ".\(choice.label)"
            case .custom:
                return ".custom(\(Int(customRadius)))"
            }
        }()

        return """
        let style: CornerStyle = \(styleString)

        Rectangle()
            .fill(.primaryBlue)
            .clipCornerStyle(style)

        // Or used inside another component:
        Button("Tap") { }
            .buttonStyle(.app(variant: .primary, cornerStyle: style))

        myView.cardStyle(cornerStyle: style)
        """
    }
}

private struct ShapePreview: View {
    var body: some View {
        LinearGradient(
            colors: [.primaryBlue, .primaryRed],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    private let presets: [(label: String, style: CornerStyle, radius: String)] = [
        ("small",          .small,          "8pt"),
        ("medium",         .medium,         "12pt"),
        ("large",          .large,          "16pt"),
        ("capsule",        .capsule,        "fully rounded"),
        ("custom(0)",      .custom(0),      "0pt — square"),
        ("custom(24)",     .custom(24),     "24pt"),
        ("custom(40)",     .custom(40),     "40pt"),
    ]

    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Shape Previews") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: medium)],
                          spacing: medium) {
                    ForEach(Array(presets.enumerated()), id: \.offset) { _, preset in
                        VStack(spacing: small) {
                            ShapePreview()
                                .clipCornerStyle(preset.style)
                                .frame(height: 80)

                            VStack(spacing: 2) {
                                Text(".\(preset.label)")
                                    .font(.caption.monospaced())
                                Text(preset.radius)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            CombinationGroup(title: "Applied to AppButtonStyle") {
                VStack(spacing: small) {
                    ForEach(CornerStyle.pickables) { item in
                        Button(item.label.capitalized) { }
                            .buttonStyle(.app(variant: .primary, cornerStyle: item.value))
                    }
                }
            }

            CombinationGroup(title: "Applied to CardStyle") {
                VStack(spacing: small) {
                    ForEach(CornerStyle.pickables) { item in
                        Text(".\(item.label)")
                            .font(.subheadline.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cardStyle(cornerStyle: item.value, shadow: .small)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { CornerStyleDemo() }
}
