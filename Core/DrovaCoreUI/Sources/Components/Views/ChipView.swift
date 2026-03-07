//
//  ChipView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Chip Mode

/// Defines the interaction mode of a chip
public enum ChipMode {
    /// Interactive chip that can be toggled (supports isActive state and chevron)
    case interactive
    /// Non-interactive display chip with optional icons
    case display
}

/// A reusable chip component for filters and status display
/// Supports interactive mode with active/inactive states and chevron,
/// or display mode with optional leading/trailing icons
public struct ChipView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }

    // MARK: - Properties

    /// The label text to display
    private let label: String
    
    /// The chip mode (interactive or display)
    private let mode: ChipMode
    
    /// The chip style
    private let style: ChipStyle

    /// Whether the chip is in active state (interactive mode only)
    private let isActive: Bool

    /// Whether to show the chevron accessory (interactive mode only)
    private let showChevron: Bool
    
    /// Optional leading icon (display mode only)
    private let leadingIcon: Icons?
    
    /// Optional trailing icon (display mode only)
    private let trailingIcon: Icons?

    /// Optional action when chip is tapped
    private let action: (() -> Void)?

    // MARK: - Initialization (Interactive Mode)

    /// Creates an interactive chip with a label and state
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
        self.mode = .interactive
        self.style = .normal
        self.isActive = isActive
        self.showChevron = showChevron
        self.leadingIcon = nil
        self.trailingIcon = nil
        self.action = action
    }
    
    // MARK: - Initialization (Display Mode)
    
    /// Creates a non-interactive display chip with a style and optional icons
    /// - Parameters:
    ///   - label: The text to display on the chip
    ///   - style: The visual style of the chip
    ///   - leadingIcon: Optional icon to display before the label
    ///   - trailingIcon: Optional icon to display after the label
    public init(
        _ label: String,
        style: ChipStyle,
        leadingIcon: Icons? = nil,
        trailingIcon: Icons? = nil
    ) {
        self.label = label
        self.mode = .display
        self.style = style
        self.isActive = false
        self.showChevron = false
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.action = nil
    }

    // MARK: - Body

    public var body: some View {
        if let action {
            Button {
                action()
            } label: {
                chipContent
            }
            .buttonStyle(.plain)
        } else {
            chipContent
        }
    }

    // MARK: - Chip Content
    
    private var chipContent: some View {
        HStack(spacing: 6) {
            if let leadingIcon {
                Icon(leadingIcon, size: .small, color: contentColor)
            }
            
            Text(label)
                .font(.subheadline)
                .fontWeight(isEmphasized ? .semibold : .regular)
            
            if let trailingIcon {
                Icon(trailingIcon, size: .small, color: contentColor)
            }
            
            if showChevron {
                Icon(
                    isActive ? .chevronUp : .chevronDown,
                    size: .small,
                    color: contentColor
                )
            }
        }
        .bold()
        .foregroundStyle(contentColor)
        .cardStyle(
            paddingHorizontal: smallMedium,
            paddingVertical: small,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerStyle: .capsule
        )
    }
    
    // MARK: - Computed Properties
    
    private var isEmphasized: Bool {
        isActive || style != .normal
    }
    
    private var resolvedStyle: ChipStyle {
        if mode == .interactive {
            return isActive ? .accent : .normal
        }
        return style
    }
    
    private var contentColor: Color {
        resolvedStyle.contentColor(for: colors)
    }
    
    private var backgroundColor: Color {
        resolvedStyle.backgroundColor(for: colors)
    }
    
    private var borderColor: Color {
        resolvedStyle.borderColor(for: colors)
    }
}

// MARK: - Preview

private struct ChipPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mediumBig) {
                
                // Interactive chips
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive Mode")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        ChipView("Inactive")
                        ChipView("Active", isActive: true)
                    }
                    
                    HStack(spacing: small) {
                        ChipView("Inactive", showChevron: true)
                        ChipView("Active", isActive: true, showChevron: true)
                    }
                }
                
                // Display mode - All styles
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Display Mode - Styles")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        ChipView("Normal", style: .normal)
                        ChipView("Accent", style: .accent)
                    }
                    
                    HStack(spacing: small) {
                        ChipView("Info", style: .info)
                        ChipView("Danger", style: .danger)
                        ChipView("Warning", style: .warning)
                    }
                }
                
                // Display mode with icons
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Display Mode - With Icons")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    VStack(alignment: .leading, spacing: small) {
                        HStack(spacing: small) {
                            ChipView("Leading Icon", style: .accent, leadingIcon: Icons.checkmark)
                            ChipView("Trailing Icon", style: .info, trailingIcon: Icons.arrowRight)
                        }
                        
                        HStack(spacing: small) {
                            ChipView("Both Icons", style: .warning, leadingIcon: Icons.warning, trailingIcon: Icons.chevronRight)
                        }
                    }
                }
                
                // Status indicators
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Status Indicators")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: small) {
                        ChipView("Active", style: .accent, leadingIcon: Icons.checkmarkCircleFill)
                        ChipView("Pending", style: .warning, leadingIcon: Icons.clockFill)
                        ChipView("Failed", style: .danger, leadingIcon: Icons.xmarkCircleFill)
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
                
            }
            .padding()
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

