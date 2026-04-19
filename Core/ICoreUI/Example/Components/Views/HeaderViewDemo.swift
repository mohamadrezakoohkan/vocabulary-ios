//
//  HeaderViewDemo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct HeaderViewDemo: View {
    var body: some View {
        DemoScreen(
            title: "HeaderView",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private enum HeaderAccessoryKind: String, CaseIterable, Identifiable {
    case none = "None"
    case displayChip = "Display Chip"
    case interactiveChip = "Interactive Chip"
    case subtitle = "Subtitle"
    var id: String { rawValue }
}

private struct Interactive: View {
    @State private var title: String = "My Words"
    @State private var accessory: HeaderAccessoryKind = .displayChip

    @State private var chipLabel: String = "🔥 12"
    @State private var chipStyle: ChipStyle = .warning
    @State private var chipIcon: OptionalIcon = .none

    @State private var isActive: Bool = false
    @State private var showChevron: Bool = false

    @State private var subtitle: String = "3 words surfaced"

    var body: some View {
        InteractiveScroll {
            PreviewSurface(alignment: .leading) { previewHeader }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Title", text: $title)

                LabeledRow(label: "Accessory") {
                    Picker("", selection: $accessory) {
                        ForEach(HeaderAccessoryKind.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .labelsHidden()
                }

                switch accessory {
                case .none:
                    EmptyView()
                case .displayChip:
                    TextFieldRow(label: "Chip label", text: $chipLabel)
                    LabeledRow(label: "Chip style") {
                        Picker("", selection: $chipStyle) {
                            ForEach(ChipStyle.pickables) { Text($0.label).tag($0.value) }
                        }
                        .labelsHidden()
                    }
                    LabeledRow(label: "Chip icon") {
                        Picker("", selection: $chipIcon) {
                            ForEach(OptionalIcon.all) { Text($0.label).tag($0) }
                        }
                        .labelsHidden()
                    }
                case .interactiveChip:
                    TextFieldRow(label: "Chip label", text: $chipLabel)
                    Toggle("Is active",   isOn: $isActive).font(.subheadline)
                    Toggle("Show chevron", isOn: $showChevron).font(.subheadline)
                case .subtitle:
                    TextFieldRow(label: "Subtitle", text: $subtitle)
                }
            }
        }
    }

    @ViewBuilder
    private var previewHeader: some View {
        switch accessory {
        case .none:
            HeaderView(title)
        case .displayChip:
            HeaderView(title, chipLabel: chipLabel, chipStyle: chipStyle, chipIcon: chipIcon.value)
        case .interactiveChip:
            HeaderView(title,
                       chipLabel: chipLabel,
                       isActive: isActive,
                       showChevron: showChevron) {
                isActive.toggle()
            }
        case .subtitle:
            HeaderView(title, subtitle: subtitle)
        }
    }

    private var codeSnippet: String {
        switch accessory {
        case .none:
            return swiftCall("HeaderView", positional: [swiftStringLiteral(title)])
        case .displayChip:
            let styleLabel = ChipStyle.pickables.first { $0.value == chipStyle }?.label ?? "accent"
            return swiftCall(
                "HeaderView",
                positional: [swiftStringLiteral(title)],
                arguments: [
                    ("chipLabel", swiftStringLiteral(chipLabel)),
                    ("chipStyle", ".\(styleLabel)"),
                    ("chipIcon",  chipIcon.code),
                ]
            )
        case .interactiveChip:
            return swiftCall(
                "HeaderView",
                positional: [swiftStringLiteral(title)],
                arguments: [
                    ("chipLabel",   swiftStringLiteral(chipLabel)),
                    ("isActive",    isActive ? "true" : "false"),
                    ("showChevron", showChevron ? "true" : "false"),
                    ("action",      "{ /* toggle */ }"),
                ]
            )
        case .subtitle:
            return swiftCall(
                "HeaderView",
                positional: [swiftStringLiteral(title)],
                arguments: [("subtitle", swiftStringLiteral(subtitle))]
            )
        }
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Plain Title") {
                HeaderView("My Words")
            }

            CombinationGroup(title: "Display Chip — Each Style") {
                VStack(alignment: .leading, spacing: medium) {
                    ForEach(ChipStyle.pickables) { item in
                        HeaderView("Review",
                                   chipLabel: "🔥 12",
                                   chipStyle: item.value)
                    }
                }
            }

            CombinationGroup(title: "Display Chip + Icon") {
                VStack(alignment: .leading, spacing: medium) {
                    HeaderView("Today",
                               chipLabel: "Saved",
                               chipStyle: .success,
                               chipIcon: .checkmarkCircleFill)
                    HeaderView("Alerts",
                               chipLabel: "Active",
                               chipStyle: .warning,
                               chipIcon: .warning)
                    HeaderView("Cards",
                               chipLabel: "12",
                               chipStyle: .info,
                               chipIcon: .star)
                }
            }

            CombinationGroup(title: "Interactive Chip") {
                VStack(alignment: .leading, spacing: medium) {
                    HeaderView("Filter", chipLabel: "Off", isActive: false)
                    HeaderView("Filter", chipLabel: "On",  isActive: true)
                    HeaderView("Sort",   chipLabel: "Newest",
                               isActive: false, showChevron: true)
                    HeaderView("Sort",   chipLabel: "Oldest",
                               isActive: true, showChevron: true)
                }
            }

            CombinationGroup(title: "Subtitle") {
                VStack(alignment: .leading, spacing: medium) {
                    HeaderView("Today",   subtitle: "3 words surfaced")
                    HeaderView("Lineage", subtitle: "Track how thoughts evolved over time")
                }
            }
        }
    }
}

#Preview {
    NavigationStack { HeaderViewDemo() }
}
