//
//  HeaderView.swift
//  ICoreUI
//
//  Bauhaus header — uppercase, bold, tracked. Left-aligned by default.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Views/HeaderViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever a new accessory mode, init, or layout variant is added.
//

import SwiftUI

public enum HeaderChipMode {
    case display(style: ChipStyle, leadingIcon: Icons? = nil)
    case interactive(isActive: Bool, showChevron: Bool, action: (() -> Void)?)
}

public enum HeaderAccessory {
    case chip(label: String, mode: HeaderChipMode)
    case subtitle(String)
}

public struct HeaderView: View {
    private let title: String
    private let accessory: HeaderAccessory?

    public init(_ title: String) {
        self.title = title
        self.accessory = nil
    }

    public init(_ title: String, accessory: HeaderAccessory) {
        self.title = title
        self.accessory = accessory
    }

    public init(
        _ title: String,
        chipLabel: String,
        chipStyle: ChipStyle = .accent,
        chipIcon: Icons? = nil
    ) {
        self.title = title
        self.accessory = .chip(
            label: chipLabel,
            mode: .display(style: chipStyle, leadingIcon: chipIcon)
        )
    }

    public init(
        _ title: String,
        chipLabel: String,
        isActive: Bool,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.accessory = .chip(
            label: chipLabel,
            mode: .interactive(isActive: isActive, showChevron: showChevron, action: action)
        )
    }

    public init(_ title: String, subtitle: String) {
        self.title = title
        self.accessory = .subtitle(subtitle)
    }

    public var body: some View {
        switch accessory {
        case .chip(let label, let mode):
            HStack(alignment: .center) {
                titleText
                Spacer()
                chipView(label: label, mode: mode)
            }
        case .subtitle(let subtitle):
            VStack(alignment: .leading, spacing: extraSmall) {
                titleText
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.foregroundMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .none:
            titleText
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private func chipView(label: String, mode: HeaderChipMode) -> some View {
        switch mode {
        case .display(let style, let leadingIcon):
            ChipView(label, style: style, leadingIcon: leadingIcon)
        case .interactive(let isActive, let showChevron, let action):
            ChipView(label, isActive: isActive, showChevron: showChevron, action: action)
        }
    }

    private var titleText: some View {
        Text(title)
            .font(.title.weight(.black))
            .textCase(.uppercase)
            .tracking(-0.5)
            .foregroundStyle(.foreground)
    }
}

// MARK: - Preview

private struct HeaderPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mediumBig) {
                HeaderView("My Words")
                HeaderView("Review", chipLabel: "🔥 12", chipStyle: .warning)
                HeaderView("Today", subtitle: "3 words surfaced")
            }
            .padding(medium)
        }
        .background(.background)
    }
}

#Preview("Light Mode") {
    HeaderPreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HeaderPreview().preferredColorScheme(.dark)
}
