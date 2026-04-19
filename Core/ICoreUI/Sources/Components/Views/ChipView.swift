//
//  ChipView.swift
//  ICoreUI
//
//  Filled capsule chip — filter toggles, status indicators, or inline labels.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Do NOT add borders, hard shadows, uppercase text, or letter tracking.
//  - Chips use solid filled backgrounds with contrasting on-colors from Colors.swift.
//  - Interactive chips toggle between .normal and .accent styles.
//  - Display chips are static and accept any ChipStyle.
//  - Keep two inits only: display (style-based) and interactive (isActive-based).
//  - Icons use .normal size to match .subheadline text. Do not use .small.
//  - Press animation uses spring with opacity + scale — no translate or shadow removal.
//  - Previews use native List with sections.
//  - Demo: Core/ICoreUI/Example/Components/Views/ChipViewDemo.swift
//    Update the Interactive controls and Combinations matrix there
//    whenever an init, style, or behavior changes.
//

import SwiftUI

public struct ChipView: View {
    private let label: String
    private let style: ChipStyle
    private let isActive: Bool
    private let showChevron: Bool
    private let leadingIcon: Icons?
    private let trailingIcon: Icons?
    private let action: (() -> Void)?

    /// Display chip.
    public init(
        _ label: String,
        style: ChipStyle,
        leadingIcon: Icons? = nil,
        trailingIcon: Icons? = nil
    ) {
        self.label = label
        self.style = style
        self.isActive = false
        self.showChevron = false
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.action = nil
    }

    /// Interactive chip — toggles between normal and accent.
    public init(
        _ label: String,
        isActive: Bool = false,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.label = label
        self.style = isActive ? .accent : .normal
        self.isActive = isActive
        self.showChevron = showChevron
        self.leadingIcon = nil
        self.trailingIcon = nil
        self.action = action
    }

    public var body: some View {
        if let action {
            Button(action: action) { content }
                .buttonStyle(ChipButtonStyle())
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: 6) {
            if let leadingIcon {
                Icon(leadingIcon, size: .normal, color: style.contentColor)
            }

            Text(label)
                .font(.subheadline.weight(.medium))

            if let trailingIcon {
                Icon(trailingIcon, size: .normal, color: style.contentColor)
            }

            if showChevron {
                Image(systemName: isActive ? "chevron.up" : "chevron.down")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(style.contentColor)
            }
        }
        .foregroundStyle(style.contentColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(style.backgroundColor)
        .clipShape(Capsule())
    }
}

// MARK: - Button Style

private struct ChipButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

// MARK: - Preview

private struct ChipPreview: View {
    @State private var filterActive = false

    var body: some View {
        List {
            Section("Interactive") {
                HStack(spacing: small) {
                    ChipView("Filter", isActive: filterActive) {
                        filterActive.toggle()
                    }
                    ChipView("Menu", isActive: false, showChevron: true)
                }
            }

            Section("Display") {
                HStack(spacing: small) {
                    ChipView("Normal", style: .normal)
                    ChipView("Accent", style: .accent)
                    ChipView("Info", style: .info)
                }
                HStack(spacing: small) {
                    ChipView("Success", style: .success)
                    ChipView("Warning", style: .warning)
                    ChipView("Danger", style: .danger)
                }
            }

            Section("With Icons") {
                HStack(spacing: small) {
                    ChipView("Saved", style: .success, leadingIcon: .checkmarkCircleFill)
                    ChipView("Alert", style: .danger, leadingIcon: .warning)
                }
            }
        }
    }
}

#Preview("Light") {
    ChipPreview().preferredColorScheme(.light)
}

#Preview("Dark") {
    ChipPreview().preferredColorScheme(.dark)
}
