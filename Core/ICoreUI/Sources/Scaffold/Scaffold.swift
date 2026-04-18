//
//  Scaffold.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Scaffold Header Configuration

/// Configuration for the scaffold header.
public struct ScaffoldHeaderConfig {
    public let title: String
    public let accessory: HeaderAccessory?
    public let headerHeight: CGFloat
    public let blurGradientHeight: CGFloat
    public let horizontalPadding: CGFloat
    
    public init(
        title: String,
        accessory: HeaderAccessory? = nil,
        headerHeight: CGFloat = 60,
        blurGradientHeight: CGFloat = 10,
        horizontalPadding: CGFloat = medium
    ) {
        self.title = title
        self.accessory = accessory
        self.headerHeight = headerHeight
        self.blurGradientHeight = blurGradientHeight
        self.horizontalPadding = horizontalPadding
    }
    
    /// Creates a header config with a chip accessory.
    public static func chip(
        title: String,
        chipLabel: String,
        chipStyle: ChipStyle = .accent,
        chipIcon: Icons? = nil,
        headerHeight: CGFloat = 60,
        blurGradientHeight: CGFloat = 10,
        horizontalPadding: CGFloat = medium
    ) -> ScaffoldHeaderConfig {
        ScaffoldHeaderConfig(
            title: title,
            accessory: .chip(label: chipLabel, mode: .display(style: chipStyle, leadingIcon: chipIcon)),
            headerHeight: headerHeight,
            blurGradientHeight: blurGradientHeight,
            horizontalPadding: horizontalPadding
        )
    }
    
    /// Creates a header config with a subtitle.
    public static func subtitle(
        title: String,
        subtitle: String,
        headerHeight: CGFloat = 70,
        blurGradientHeight: CGFloat = 10,
        horizontalPadding: CGFloat = medium
    ) -> ScaffoldHeaderConfig {
        ScaffoldHeaderConfig(
            title: title,
            accessory: .subtitle(subtitle),
            headerHeight: headerHeight,
            blurGradientHeight: blurGradientHeight,
            horizontalPadding: horizontalPadding
        )
    }
}

// MARK: - ScaffoldView Protocol

/// A protocol for views that automatically get themed scaffold features applied.
///
/// Conform to `ScaffoldView` instead of `View` and implement `content` instead of `body`.
/// The scaffold background, loading overlay, empty state, and header are applied automatically.
///
/// ```swift
/// // Basic usage:
/// struct MyScreen: ScaffoldView {
///     var content: some View {
///         Text("Hello")
///     }
/// }
///
/// // With loading and empty state:
/// struct ItemsScreen: ScaffoldView {
///     @State private var items: [Item] = []
///     @State private var isLoading = true
///
///     var isLoadingContent: Bool { isLoading }
///     var isEmpty: Bool { items.isEmpty && !isLoading }
///     var emptyState: EmptyStateConfig? {
///         EmptyStateConfig(
///             icon: .leaf,
///             title: "No items yet",
///             message: "Add your first item to get started"
///         )
///     }
///
///     var content: some View {
///         List(items) { item in
///             ItemRow(item: item)
///         }
///     }
/// }
///
/// // With header and blur gradient:
/// struct CaptureScreen: ScaffoldView {
///     var header: ScaffoldHeaderConfig? {
///         .chip(title: "Plant a Seed", chipLabel: "🔥 12 days", chipStyle: .accent)
///     }
///
///     var content: some View {
///         ScrollView {
///             // Your scrollable content
///         }
///     }
/// }
///
/// // With custom background:
/// struct SettingsScreen: ScaffoldView {
///     var background: ScaffoldBackground { .background2 }
///
///     var content: some View {
///         Text("Settings")
///     }
/// }
/// ```
public protocol ScaffoldView: View {
    associatedtype Content: View
    
    /// The background level to use. Defaults to `.background1`.
    var background: ScaffoldBackground { get }
    
    /// Whether to show the loading overlay. Defaults to `false`.
    var isLoading: Bool { get }

    /// Whether the content is empty. Defaults to `false`.
    var isEmpty: Bool { get }
    
    /// Configuration for the empty state. Return `nil` to disable empty state.
    var emptyState: EmptyStateConfig? { get }
    
    /// Configuration for the header with blur gradient. Return `nil` to disable header.
    var header: ScaffoldHeaderConfig? { get }
    
    @ViewBuilder var content: Content { get }
}

// MARK: - Default Implementations

public extension ScaffoldView {
    var background: ScaffoldBackground { .background1 }
    var isLoading: Bool { false }
    var isEmpty: Bool { false }
    var emptyState: EmptyStateConfig? { nil }
    var header: ScaffoldHeaderConfig? { nil }

    @ViewBuilder
    var body: some View {
        content
            .applyHeader(config: header)
            .applyEmptyState(isEmpty: isEmpty, config: emptyState)
            .scaffoldLoading(isLoading)
            .scaffoldBackground(background)
    }
}

// MARK: - Private Helpers

private extension View {
    @ViewBuilder
    func applyEmptyState(isEmpty: Bool, config: EmptyStateConfig?) -> some View {
        if let config = config {
            self.scaffoldEmptyState(isEmpty, config: config)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func applyHeader(config: ScaffoldHeaderConfig?) -> some View {
        if let config = config {
            self.scaffoldHeader(
                config.title,
                accessory: config.accessory,
                headerHeight: config.headerHeight,
                blurGradientHeight: config.blurGradientHeight,
                horizontalPadding: config.horizontalPadding
            )
        } else {
            self
        }
    }
}

// MARK: - Previews

private struct BasicScreen: ScaffoldView {
    var content: some View {
        VStack {
            Text("I'm using ScaffoldView!")
            Text("Background is automatic")
                .font(.caption)
        }
    }
}

private struct LoadingScreen: ScaffoldView {
    @State var isLoading: Bool = false

    var content: some View {
        Text(isLoading ? "Loading..." : "Click to load")
            .onTapGesture {
                isLoading.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading.toggle()
                })
            }
    }
}

private struct EmptyScreen: ScaffoldView {
    @State var isEmpty: Bool = true
    var emptyState: EmptyStateConfig? {
        EmptyStateConfig(
            icon: .leaf,
            title: "No memories yet",
            message: "Start capturing moments to see them here",
            actionTitle: "Capture",
            action: { isEmpty.toggle() }
        )
    }
    
    var content: some View {
        Text("This won't show when empty")
            .onTapGesture {
                isEmpty.toggle()
            }
    }
}

private struct HeaderScreen: ScaffoldView {
    @Environment(\.colorScheme) private var colorScheme
    
    var header: ScaffoldHeaderConfig? {
        .chip(title: "Plant a Seed", chipLabel: "🔥 12 days", chipStyle: .accent)
    }
    
    var content: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<15) { index in
                RoundedRectangle(cornerRadius: smallMedium)
                    .fill(colorScheme.theme.background2)
                    .frame(height: 80)
                    .overlay(
                        Text("Item \(index + 1)")
                            .foregroundStyle(colorScheme.theme.content1)
                    )
            }
        }
    }
}

private struct SubtitleHeaderScreen: ScaffoldView {
    @Environment(\.colorScheme) private var colorScheme
    
    var header: ScaffoldHeaderConfig? {
        .subtitle(title: "Today's Revisit", subtitle: "3 seeds surfaced for you")
    }
    
    var content: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<10) { index in
                RoundedRectangle(cornerRadius: smallMedium)
                    .fill(colorScheme.theme.background2)
                    .frame(height: 100)
                    .overlay(
                        Text("Card \(index + 1)")
                            .foregroundStyle(colorScheme.theme.content1)
                    )
            }
        }
    }
}

#Preview("Basic") {
    BasicScreen()
}

#Preview("Loading") {
    LoadingScreen()
}

#Preview("Empty State") {
    EmptyScreen()
}

#Preview("Header with Chip") {
    HeaderScreen()
}

#Preview("Header with Subtitle") {
    SubtitleHeaderScreen()
}

#Preview("Full Scaffold Demo") {
    FullScaffoldDemoScreen()
}

// MARK: - Full Scaffold Demo
private struct FullScaffoldDemoScreen: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var showHeader = true
    @State private var showLoading = false
    @State private var showEmpty = false
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            FullScaffoldContent(
                showHeader: showHeader,
                isLoading: showLoading,
                isEmpty: showEmpty
            )
            
            // Control panel
            VStack(spacing: medium) {
                Text("SCAFFOLD CONTROLS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(colors.content2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: small) {
                    ToggleButton(
                        title: "Header",
                        isOn: $showHeader,
                        color: colors.accentPrimary
                    )
                    
                    ToggleButton(
                        title: "Loading",
                        isOn: $showLoading,
                        color: colors.alertInfoBackground
                    )
                    
                    ToggleButton(
                        title: "Empty",
                        isOn: $showEmpty,
                        color: colors.alertWarningBackground
                    )
                }
            }
            .padding(medium)
            .background(colors.background2)
        }
    }
}

private struct FullScaffoldContent: ScaffoldView {
    @Environment(\.colorScheme) var colorScheme
    
    let showHeader: Bool
    var isLoading: Bool
    var isEmpty: Bool
    
    var header: ScaffoldHeaderConfig? {
        showHeader ? .chip(title: "Plant a Seed", chipLabel: "🔥 12 days", chipStyle: .accent) : nil
    }
    
    var emptyState: EmptyStateConfig? {
        EmptyStateConfig(
            icon: .leaf,
            title: "No seeds yet",
            message: "Start planting your first seed to see them here"
        )
    }
    
    var content: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<12) { index in
                RoundedRectangle(cornerRadius: smallMedium)
                    .fill(colorScheme.theme.background2)
                    .frame(height: 80)
                    .overlay(
                        Text("Seed \(index + 1)")
                            .foregroundStyle(colorScheme.theme.content1)
                    )
            }
        }
    }
}

private struct ToggleButton: View {
    let title: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(isOn ? .white : color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, small)
                .background(
                    RoundedRectangle(cornerRadius: small)
                        .fill(isOn ? color : color.opacity(0.15))
                )
        }
        .buttonStyle(.plain)
    }
}

