//
//  ScaffoldHeaderModifier.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Scaffold Header Modifier

/// A view modifier that provides a header with blur gradient effect when content scrolls behind it.
struct ScaffoldHeaderModifier<Header: View>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let header: Header
    let headerHeight: CGFloat
    let blurGradientHeight: CGFloat
    
    private var theme: any ColorTheme {
        colorScheme.theme
    }
    
    init(
        @ViewBuilder header: () -> Header,
        headerHeight: CGFloat = 60,
        blurGradientHeight: CGFloat = 40
    ) {
        self.header = header()
        self.headerHeight = headerHeight
        self.blurGradientHeight = blurGradientHeight
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            // Main scrollable content
            ScrollView {
                content
                    .padding(.horizontal, medium)
            }
            .safeAreaInset(edge: .top) {
                Color.clear
                    .frame(height: headerHeight)
            }
            
            // Header with blur gradient overlay
            VStack(spacing: 0) {
                // Header background with blur
                header
                    .frame(height: headerHeight)
                    .frame(maxWidth: .infinity)
                    .background(
                        theme.background1
                            .opacity(0.95)
                    )
                    .background(.ultraThinMaterial)
                
                // Blur gradient that fades content behind
                BlurGradientView(height: blurGradientHeight)
            }
        }
    }
}

// MARK: - Blur Gradient View

/// A view that creates a blur gradient effect for content scrolling behind a header.
private struct BlurGradientView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let height: CGFloat
    
    private var theme: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: theme.background1.opacity(0.9), location: 0),
                .init(color: theme.background1.opacity(0.6), location: 0.3),
                .init(color: theme.background1.opacity(0.3), location: 0.6),
                .init(color: theme.background1.opacity(0), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: height)
        .allowsHitTesting(false)
    }
}

// MARK: - View Extension

public extension View {
    /// Adds a fixed header with blur gradient effect when content scrolls behind it.
    ///
    /// - Parameters:
    ///   - headerHeight: The height of the header area. Defaults to 60.
    ///   - blurGradientHeight: The height of the blur gradient below the header. Defaults to 40.
    ///   - header: A view builder that creates the header content.
    ///
    /// ```swift
    /// ScrollView {
    ///     VStack {
    ///         // Your content
    ///     }
    /// }
    /// .scaffoldHeader {
    ///     HeaderView("My Title", chipLabel: "🔥 12 days", chipStyle: .accent)
    ///         .padding(.horizontal, medium)
    /// }
    /// ```
    func scaffoldHeader<Header: View>(
        headerHeight: CGFloat = 60,
        blurGradientHeight: CGFloat = 40,
        @ViewBuilder header: () -> Header
    ) -> some View {
        modifier(ScaffoldHeaderModifier(
            header: header,
            headerHeight: headerHeight,
            blurGradientHeight: blurGradientHeight
        ))
    }
    
    /// Adds a HeaderView as a fixed header with blur gradient effect.
    ///
    /// - Parameters:
    ///   - title: The header title.
    ///   - accessory: Optional header accessory (chip or subtitle).
    ///   - headerHeight: The height of the header area. Defaults to 60.
    ///   - blurGradientHeight: The height of the blur gradient. Defaults to 40.
    ///
    /// ```swift
    /// ScrollView {
    ///     VStack {
    ///         // Your content
    ///     }
    /// }
    /// .scaffoldHeader("Plant a Seed", accessory: .chip(label: "🔥 12 days", mode: .display(style: .accent, leadingIcon: nil)))
    /// ```
    func scaffoldHeader(
        _ title: String,
        accessory: HeaderAccessory? = nil,
        headerHeight: CGFloat = 60,
        blurGradientHeight: CGFloat = 40,
        horizontalPadding: CGFloat = medium
    ) -> some View {
        modifier(ScaffoldHeaderModifier(
            header: {
                Group {
                    if let accessory = accessory {
                        HeaderView(title, accessory: accessory)
                    } else {
                        HeaderView(title)
                    }
                }
                .padding(.horizontal, horizontalPadding)
            },
            headerHeight: headerHeight,
            blurGradientHeight: blurGradientHeight
        ))
    }
}

// MARK: - Preview

private struct ScrollingContentPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<20) { index in
                RoundedRectangle(cornerRadius: smallMedium)
                    .fill(colors.background2)
                    .frame(height: 80)
                    .overlay(
                        Text("Item \(index + 1)")
                            .foregroundStyle(colors.content1)
                    )
            }
        }
        .scaffoldHeader {
            HeaderView(
                "Plant a Seed",
                chipLabel: "🔥 12 days",
                chipStyle: .accent
            )
            .padding(.horizontal, medium)
        }
        .scaffoldBackground()
    }
}

private struct SubtitleHeaderPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<15) { index in
                RoundedRectangle(cornerRadius: smallMedium)
                    .fill(colors.background2)
                    .frame(height: 100)
                    .overlay(
                        Text("Card \(index + 1)")
                            .foregroundStyle(colors.content1)
                    )
            }
        }
        .scaffoldHeader(
            "Today's Revisit",
            accessory: .subtitle("3 seeds surfaced for you"),
            headerHeight: 70
        )
        .scaffoldBackground()
    }
}

#Preview("Scrolling with Header") {
    ScrollingContentPreview()
}

#Preview("Subtitle Header") {
    SubtitleHeaderPreview()
}

#Preview("Dark Mode") {
    ScrollingContentPreview()
        .preferredColorScheme(.dark)
}
