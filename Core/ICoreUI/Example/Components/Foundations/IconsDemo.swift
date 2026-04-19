//
//  IconsDemo.swift
//  ICoreUIExample
//
//  Showcases the `Icons` enum and the `Icon` view defined in
//  Core/ICoreUI/Sources/Icons/Icons.swift.
//

import SwiftUI
import ICoreUI

struct IconsDemo: View {
    var body: some View {
        DemoScreen(
            title: "Icons",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Size choice (collapses `.custom(CGFloat)` into a slider)

private enum IconSizeChoice: String, CaseIterable, Identifiable {
    case small, normal, large, custom

    var id: String { rawValue }
    var label: String { rawValue }
}

// MARK: - Interactive

private struct Interactive: View {
    @State private var icon: Icons = .star
    @State private var sizeChoice: IconSizeChoice = .normal
    @State private var customSize: CGFloat = 32
    @State private var color: OptionalNamedColor = OptionalNamedColor(value: .primaryRed)
    @State private var animated: Bool = true
    @State private var nonce: Int = 0

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                VStack(spacing: medium) {
                    Icon(icon, size: currentSize, color: color.color, animated: animated)
                        .id(nonce) // re-trigger animation when bumped
                    Button {
                        nonce += 1
                    } label: {
                        Label("Replay animation", systemImage: "arrow.clockwise")
                            .font(.footnote.weight(.semibold))
                    }
                    .buttonStyle(.borderless)
                    .opacity(animated ? 1 : 0.4)
                    .disabled(!animated)
                }
            }

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                LabeledRow(label: "Icon") {
                    Picker("", selection: $icon) {
                        ForEach(Icons.allCases) { item in
                            Text(item.iconCaseName).tag(item)
                        }
                    }
                    .labelsHidden()
                }

                LabeledRow(label: "Size") {
                    Picker("", selection: $sizeChoice) {
                        ForEach(IconSizeChoice.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                if sizeChoice == .custom {
                    SliderRow(label: "Custom font size", value: $customSize, range: 8...80)
                }

                LabeledRow(label: "Color") {
                    Picker("", selection: $color) {
                        ForEach(OptionalNamedColor.all) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                Toggle("Animated", isOn: $animated).font(.subheadline)
            }
        }
    }

    private var currentSize: Icon.Size {
        switch sizeChoice {
        case .small:  .small
        case .normal: .normal
        case .large:  .large
        case .custom: .custom(customSize)
        }
    }

    private var sizeCode: String {
        switch sizeChoice {
        case .small, .normal, .large: ".\(sizeChoice.label)"
        case .custom:                 ".custom(\(Int(customSize)))"
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "Icon",
            positional: [".\(icon.iconCaseName)"],
            arguments: [
                ("size",     sizeCode),
                ("color",    color.code),
                ("animated", animated ? "true" : "false"),
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "All Icons (.normal)") {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 80), spacing: small)],
                    spacing: small
                ) {
                    ForEach(Icons.allCases) { item in
                        IconTile(icon: item, size: .normal, color: .foreground)
                    }
                }
            }

            CombinationGroup(title: "Sizes") {
                VStack(alignment: .leading, spacing: medium) {
                    sizeRow(.small,           label: ".small (10pt)")
                    sizeRow(.normal,          label: ".normal (16pt)")
                    sizeRow(.large,           label: ".large (32pt)")
                    sizeRow(.custom(48),      label: ".custom(48)")
                    sizeRow(.custom(64),      label: ".custom(64)")
                }
            }

            CombinationGroup(title: "Colors") {
                VStack(alignment: .leading, spacing: small) {
                    colorRow(.primaryRed,    name: "primaryRed")
                    colorRow(.primaryBlue,   name: "primaryBlue")
                    colorRow(.primaryYellow, name: "primaryYellow")
                    colorRow(.primaryGreen,  name: "primaryGreen")
                    colorRow(.foreground,    name: "foreground")
                    colorRow(.foregroundMuted, name: "foregroundMuted")
                }
            }

            CombinationGroup(title: "Animated vs Static") {
                HStack(spacing: medium) {
                    VStack(spacing: extraSmall) {
                        Icon(.heart, size: .large, color: .primaryRed, animated: true)
                        Text("animated: true").font(.caption2)
                    }
                    VStack(spacing: extraSmall) {
                        Icon(.heart, size: .large, color: .primaryRed, animated: false)
                        Text("animated: false").font(.caption2)
                    }
                    Spacer()
                }
            }

            CombinationGroup(title: "Custom Symbol Name") {
                HStack(spacing: medium) {
                    VStack(spacing: extraSmall) {
                        Icon(iconName: "swift", size: .large, color: .primaryRed)
                        Text("\"swift\"").font(.caption2.monospaced())
                    }
                    VStack(spacing: extraSmall) {
                        Icon(iconName: "globe", size: .large, color: .primaryBlue)
                        Text("\"globe\"").font(.caption2.monospaced())
                    }
                    VStack(spacing: extraSmall) {
                        Icon(iconName: "sparkles", size: .large, color: .primaryYellow)
                        Text("\"sparkles\"").font(.caption2.monospaced())
                    }
                    Spacer()
                }
            }
        }
    }

    private func sizeRow(_ size: Icon.Size, label: String) -> some View {
        HStack(spacing: medium) {
            Icon(.star, size: size, color: .primaryYellow)
                .frame(width: 80, alignment: .leading)
            Text(label)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func colorRow(_ color: Color, name: String) -> some View {
        HStack(spacing: medium) {
            Icon(.heart, size: .normal, color: color)
                .frame(width: 40, alignment: .leading)
            Text(".\(name)")
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

// MARK: - Tile

private struct IconTile: View {
    let icon: Icons
    let size: Icon.Size
    let color: Color

    var body: some View {
        VStack(spacing: extraSmall) {
            Icon(icon, size: size, color: color)
                .frame(height: 32)
            Text(icon.iconCaseName)
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, small)
        .padding(.horizontal, extraSmall)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.foregroundMuted.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack { IconsDemo() }
}
