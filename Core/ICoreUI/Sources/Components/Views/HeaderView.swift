//
//  HeaderView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Header Chip Mode

/// Defines the chip mode for header accessories
public enum HeaderChipMode {
    /// Display mode: non-interactive chip with style and optional icon
    case display(style: ChipStyle, leadingIcon: Icons? = nil)
    /// Interactive mode: chip that can be toggled with active/inactive states
    case interactive(isActive: Bool, showChevron: Bool, action: (() -> Void)?)
}

// MARK: - Header Type

/// Defines the type of accessory displayed alongside the header title
public enum HeaderAccessory {
    /// Displays a chip with label and mode (display or interactive)
    case chip(label: String, mode: HeaderChipMode)
    /// Displays a subtitle text below the title
    case subtitle(String)
}

/// A reusable header component with title and optional accessory
/// Supports two types:
/// - Chip accessory: Title with a ChipView on the right (e.g., "Plant a Seed" + "12 days" chip)
/// - Subtitle accessory: Title with subtitle below (e.g., "Today's Revisit" + "3 seeds surfaced for you")
public struct HeaderView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    // MARK: - Properties
    
    /// The main title text
    private let title: String
    
    /// The accessory type (chip or subtitle)
    private let accessory: HeaderAccessory?
    
    // MARK: - Initialization (Title Only)
    
    /// Creates a header with just a title
    /// - Parameter title: The main title text
    public init(_ title: String) {
        self.title = title
        self.accessory = nil
    }
    
    // MARK: - Initialization (With Accessory)
    
    /// Creates a header with a title and accessory
    /// - Parameters:
    ///   - title: The main title text
    ///   - accessory: The accessory type (chip or subtitle)
    public init(_ title: String, accessory: HeaderAccessory) {
        self.title = title
        self.accessory = accessory
    }
    
    // MARK: - Convenience Initializers
    
    /// Creates a header with a display chip accessory
    /// - Parameters:
    ///   - title: The main title text
    ///   - chipLabel: The chip label text
    ///   - chipStyle: The chip style (default: .accent)
    ///   - chipIcon: Optional leading icon for the chip
    public init(
        _ title: String,
        chipLabel: String,
        chipStyle: ChipStyle = .accent,
        chipIcon: Icons? = nil
    ) {
        self.title = title
        self.accessory = .chip(label: chipLabel, mode: .display(style: chipStyle, leadingIcon: chipIcon))
    }
    
    /// Creates a header with an interactive chip accessory
    /// - Parameters:
    ///   - title: The main title text
    ///   - chipLabel: The chip label text
    ///   - isActive: Whether the chip is in active state
    ///   - showChevron: Whether to show the chevron accessory
    ///   - action: Action to perform when the chip is tapped
    public init(
        _ title: String,
        chipLabel: String,
        isActive: Bool,
        showChevron: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.accessory = .chip(label: chipLabel, mode: .interactive(isActive: isActive, showChevron: showChevron, action: action))
    }
    
    /// Creates a header with a subtitle
    /// - Parameters:
    ///   - title: The main title text
    ///   - subtitle: The subtitle text
    public init(_ title: String, subtitle: String) {
        self.title = title
        self.accessory = .subtitle(subtitle)
    }
    
    // MARK: - Body
    
    public var body: some View {
        switch accessory {
        case .chip(let label, let mode):
            chipHeader(label: label, mode: mode)
        case .subtitle(let subtitle):
            subtitleHeader(subtitle: subtitle)
        case .none:
            titleOnlyHeader
        }
    }
    
    // MARK: - Private Views
    
    /// Header with chip accessory (horizontal layout)
    @ViewBuilder
    private func chipHeader(label: String, mode: HeaderChipMode) -> some View {
        HStack(alignment: .center) {
            titleText
            Spacer()
            chipView(label: label, mode: mode)
        }
    }
    
    /// Creates the appropriate ChipView based on mode
    @ViewBuilder
    private func chipView(label: String, mode: HeaderChipMode) -> some View {
        switch mode {
        case .display(let style, let leadingIcon):
            ChipView(label, style: style, leadingIcon: leadingIcon)
        case .interactive(let isActive, let showChevron, let action):
            ChipView(label, isActive: isActive, showChevron: showChevron, action: action)
        }
    }
    
    /// Header with subtitle (vertical layout)
    private func subtitleHeader(subtitle: String) -> some View {
        VStack(alignment: .center, spacing: extraSmall) {
            titleText
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(colors.content2)
        }
    }
    
    /// Header with title only
    private var titleOnlyHeader: some View {
        titleText
    }
    
    /// The main title text view
    private var titleText: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.serif)
            .foregroundStyle(colors.content1)
    }
}

// MARK: - Preview

private struct HeaderPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mediumBig) {
                
                // Title only
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Title Only")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView("My Seeds")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // With chip - like "Plant a Seed" example
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("With Chip (Screenshot 1)")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView(
                        "Plant a Seed",
                        chipLabel: "🔥 12 days",
                        chipStyle: .accent
                    )
                }
                
                // With subtitle - like "Today's Revisit" example
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("With Subtitle (Screenshot 2)")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView(
                        "Today's Revisit",
                        subtitle: "3 seeds surfaced for you"
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Additional examples
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Additional Examples")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView(
                        "Active Seeds",
                        chipLabel: "5 growing",
                        chipStyle: .accent,
                        chipIcon: .leaf
                    )
                    
                    HeaderView(
                        "Weekly Summary",
                        subtitle: "Your progress this week"
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Interactive chip examples
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive Chips")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView(
                        "Filter Seeds",
                        chipLabel: "All",
                        isActive: false,
                        showChevron: true
                    )
                    
                    HeaderView(
                        "Sort By",
                        chipLabel: "Date",
                        isActive: true,
                        showChevron: true
                    )
                }
                
                // Interactive demo
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive Demo")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    InteractiveHeaderDemo()
                }
                
                // Using accessory enum directly
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Using Accessory Enum")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    HeaderView(
                        "Garden Overview",
                        accessory: .chip(label: "Hot", mode: .display(style: .warning, leadingIcon: .flame))
                    )
                    
                    HeaderView(
                        "Archive",
                        accessory: .subtitle("12 seeds resting")
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .background(colors.background1)
    }
}

// MARK: - Interactive Demo

private struct InteractiveHeaderDemo: View {
    @State private var isFilterActive = false
    
    var body: some View {
        HeaderView(
            "My Seeds",
            chipLabel: isFilterActive ? "Active" : "All",
            isActive: isFilterActive,
            showChevron: true
        ) {
            isFilterActive.toggle()
        }
    }
}

#Preview("Light Mode") {
    HeaderPreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HeaderPreview()
        .preferredColorScheme(.dark)
}
