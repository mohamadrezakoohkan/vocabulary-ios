//
//  ColorsDemo.swift
//  ICoreUIExample
//
//  Showcases every adaptive Color extension defined in
//  Core/ICoreUI/Sources/Colors/Colors.swift.
//

import SwiftUI
import ICoreUI

struct ColorsDemo: View {
    var body: some View {
        DemoScreen(
            title: "Colors",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Catalog

private enum ColorGroup: String, CaseIterable {
    case neutrals = "Neutrals"
    case primaries = "Primaries"
    case onColors = "On-Colors"
    case cefrLevels = "CEFR Levels"
}

private struct ColorEntry: Identifiable, Hashable {
    let name: String
    let group: ColorGroup
    let color: Color

    var id: String { name }
    var code: String { ".\(name)" }
}

private let allColors: [ColorEntry] = [
    // Neutrals
    .init(name: "background",      group: .neutrals,   color: .background),
    .init(name: "surface",         group: .neutrals,   color: .surface),
    .init(name: "foreground",      group: .neutrals,   color: .foreground),
    .init(name: "foregroundMuted", group: .neutrals,   color: .foregroundMuted),
    .init(name: "muted",           group: .neutrals,   color: .muted),
    .init(name: "border",          group: .neutrals,   color: .border),
    .init(name: "shadow",          group: .neutrals,   color: .shadow),

    // Primaries
    .init(name: "primaryRed",      group: .primaries,  color: .primaryRed),
    .init(name: "primaryBlue",     group: .primaries,  color: .primaryBlue),
    .init(name: "primaryYellow",   group: .primaries,  color: .primaryYellow),
    .init(name: "primaryGreen",    group: .primaries,  color: .primaryGreen),

    // On-Colors
    .init(name: "onRed",           group: .onColors,   color: .onRed),
    .init(name: "onBlue",          group: .onColors,   color: .onBlue),
    .init(name: "onYellow",        group: .onColors,   color: .onYellow),
    .init(name: "onGreen",         group: .onColors,   color: .onGreen),

    // CEFR Levels
    .init(name: "levelA1",         group: .cefrLevels, color: .levelA1),
    .init(name: "levelA2",         group: .cefrLevels, color: .levelA2),
    .init(name: "levelB1",         group: .cefrLevels, color: .levelB1),
    .init(name: "levelB2",         group: .cefrLevels, color: .levelB2),
]

// MARK: - Interactive

private struct Interactive: View {
    @State private var entry: ColorEntry = allColors[7] // primaryRed
    @State private var sampleText: String = "Sample"
    @State private var pairing: ColorEntry = allColors[12] // onRed

    var body: some View {
        InteractiveScroll {
            PreviewSurface {
                VStack(spacing: medium) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(entry.color)
                        .overlay(
                            VStack(spacing: extraSmall) {
                                Text(entry.name)
                                    .font(.title3.weight(.bold))
                                Text(entry.code)
                                    .font(.caption.monospaced())
                                    .opacity(0.85)
                            }
                            .foregroundStyle(pairing.color)
                        )
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.foregroundMuted.opacity(0.2), lineWidth: 1)
                        )

                    Text(sampleText)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(entry.color)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                LabeledRow(label: "Color") {
                    Picker("", selection: $entry) {
                        ForEach(ColorGroup.allCases, id: \.self) { group in
                            Section(group.rawValue) {
                                ForEach(allColors.filter { $0.group == group }) { item in
                                    Text(item.name).tag(item)
                                }
                            }
                        }
                    }
                    .labelsHidden()
                }

                LabeledRow(label: "Pairing (text)") {
                    Picker("", selection: $pairing) {
                        ForEach(ColorGroup.allCases, id: \.self) { group in
                            Section(group.rawValue) {
                                ForEach(allColors.filter { $0.group == group }) { item in
                                    Text(item.name).tag(item)
                                }
                            }
                        }
                    }
                    .labelsHidden()
                }

                TextFieldRow(label: "Sample text", text: $sampleText)
            }
        }
    }

    private var codeSnippet: String {
        """
        // Fill
        Rectangle()
            .fill(Color\(entry.code))

        // Foreground
        Text(\(swiftStringLiteral(sampleText)))
            .foregroundStyle(Color\(entry.code))

        // Pair with on-color text
        Text(\(swiftStringLiteral(sampleText)))
            .foregroundStyle(Color\(pairing.code))
            .padding()
            .background(Color\(entry.code))
        """
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            ForEach(ColorGroup.allCases, id: \.self) { group in
                CombinationGroup(title: group.rawValue) {
                    VStack(spacing: small) {
                        ForEach(allColors.filter { $0.group == group }) { item in
                            ColorRow(entry: item)
                        }
                    }
                }
            }

            CombinationGroup(title: "Recommended Pairings") {
                VStack(spacing: small) {
                    pairingCard("primaryRed",    background: .primaryRed,    text: .onRed)
                    pairingCard("primaryBlue",   background: .primaryBlue,   text: .onBlue)
                    pairingCard("primaryYellow", background: .primaryYellow, text: .onYellow)
                    pairingCard("primaryGreen",  background: .primaryGreen,  text: .onGreen)
                }
            }

            CombinationGroup(title: "CEFR Level Cards") {
                VStack(spacing: small) {
                    levelCard("A1 — Beginner",     background: .levelA1, text: .onYellow)
                    levelCard("A2 — Elementary",   background: .levelA2, text: .onRed)
                    levelCard("B1 — Intermediate", background: .levelB1, text: .onBlue)
                    levelCard("B2 — Upper Int.",   background: .levelB2, text: .background)
                }
            }
        }
    }

    private func pairingCard(_ name: String, background: Color, text: Color) -> some View {
        HStack {
            Text("\(name) + on-color")
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text("Aa")
                .font(.body.weight(.bold))
        }
        .foregroundStyle(text)
        .padding(medium)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func levelCard(_ title: String, background: Color, text: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
            Text("Card with level color background")
                .font(.subheadline)
                .opacity(0.85)
        }
        .foregroundStyle(text)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(medium)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Color Row

private struct ColorRow: View {
    let entry: ColorEntry

    var body: some View {
        HStack(spacing: small) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(entry.color)
                .frame(width: 44, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.foregroundMuted.opacity(0.2), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.subheadline.weight(.semibold))
                Text(entry.code)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
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

#Preview {
    NavigationStack { ColorsDemo() }
}
