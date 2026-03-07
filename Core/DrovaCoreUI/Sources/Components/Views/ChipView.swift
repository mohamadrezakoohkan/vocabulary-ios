//
//  ChipView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

/// A reusable chip component for filters with active/inactive states
/// Features capsule shape, small padding, and optional chevron accessory
public struct ChipView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }

    // MARK: - Properties

    /// The label text to display
    private let label: String

    /// Whether the chip is in active state
    private let isActive: Bool

    /// Whether to show the chevron accessory
    private let showChevron: Bool

    /// Optional action when chip is tapped
    private let action: (() -> Void)?

    // MARK: - Initialization

    /// Creates a chip with a label and state
    /// - Parameters:
    ///   - label: The text to display on the chip
    ///   - isActive: Whether the chip is in active state (default: false)
    ///   - showChevron: Whether to show the chevron accessory (default: false)
    ///   - action: Optional action to perform when tapped
    public init(
        _ label: String,
        isActive: Bool = false,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.label = label
        self.isActive = isActive
        self.showChevron = showChevron
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 6) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(isActive ? .semibold : .regular)

                if showChevron {
                    Icon(
                        isActive ? Icons.chevronUp : Icons.chevronDown,
                        size: Icon.Size.small,
                        color: isActive ? colors.accentContent : colors.content1
                    )
                    .bold()
                }
            }
            .foregroundStyle(isActive ? colors.accentContent : colors.content1)
            .cardStyle(
                paddingHorizontal: smallMedium,
                paddingVertical: small,
                backgroundColor: isActive ? colors.accentBackground : colors.background2,
                borderColor: isActive ? colors.accentBorder : colors.border1,
                cornerStyle: .capsule
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

private struct ChipPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: mediumBig) {

            // Basic chips
            VStack(alignment: .leading, spacing: smallMedium) {
                Text("Basic States")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)

                HStack(spacing: small) {
                    ChipView("Inactive")
                    ChipView("Active", isActive: true)
                }
            }

            // Chips with chevron
            VStack(alignment: .leading, spacing: smallMedium) {
                Text("With Chevron Accessory")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)

                HStack(spacing: small) {
                    ChipView("Inactive", showChevron: true)
                    ChipView("Active", isActive: true, showChevron: true)
                }
            }

            // Filter examples
            VStack(alignment: .leading, spacing: smallMedium) {
                Text("Filter Use Case")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)

                VStack(alignment: .leading, spacing: small) {
                    HStack(spacing: small) {
                        ChipView("All Seeds", isActive: true)
                        ChipView("Active")
                        ChipView("Hot", isActive: true)
                    }

                    HStack(spacing: small) {
                        ChipView("Date", showChevron: true)
                        ChipView("Generation", isActive: true, showChevron: true)
                        ChipView("Type", showChevron: true)
                    }
                }
            }

            // Interactive demo
            VStack(alignment: .leading, spacing: smallMedium) {
                Text("Interactive Example")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)

                InteractiveChipDemo()
            }

            // Size comparison
            VStack(alignment: .leading, spacing: smallMedium) {
                Text("Different Labels")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)

                HStack(spacing: small) {
                    ChipView("A")
                    ChipView("Short")
                    ChipView("Medium Label")
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(colors.background1)
    }
}

// MARK: - Interactive Demo

/// Demo component showing interactive chip behavior
private struct InteractiveChipDemo: View {
    @State private var selectedFilter: String? = nil

    private let filters = ["All", "Active", "Resting", "Archived"]

    var body: some View {
        HStack(spacing: small) {
            ForEach(filters, id: \.self) { filter in
                ChipView(
                    filter,
                    isActive: selectedFilter == filter,
                    showChevron: filter == "Archived"
                ) {
                    if selectedFilter == filter {
                        selectedFilter = nil
                    } else {
                        selectedFilter = filter
                    }
                }
            }
        }
    }
}

#Preview("Light Mode") {
    ChipPreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ChipPreview()
        .preferredColorScheme(.dark)
}

