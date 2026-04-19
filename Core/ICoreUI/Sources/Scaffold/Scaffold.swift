//
//  Scaffold.swift
//  ICoreUI
//

import SwiftUI

// MARK: - Scaffold Header Configuration

public struct ScaffoldHeaderConfig {
    public let title: String
    public let accessory: HeaderAccessory?
    public let headerHeight: CGFloat
    public let horizontalPadding: CGFloat

    public init(
        title: String,
        accessory: HeaderAccessory? = nil,
        headerHeight: CGFloat = 60,
        horizontalPadding: CGFloat = medium
    ) {
        self.title = title
        self.accessory = accessory
        self.headerHeight = headerHeight
        self.horizontalPadding = horizontalPadding
    }

    public static func chip(
        title: String,
        chipLabel: String,
        chipStyle: ChipStyle = .accent,
        chipIcon: Icons? = nil,
        headerHeight: CGFloat = 60,
        horizontalPadding: CGFloat = medium
    ) -> ScaffoldHeaderConfig {
        ScaffoldHeaderConfig(
            title: title,
            accessory: .chip(label: chipLabel, mode: .display(style: chipStyle, leadingIcon: chipIcon)),
            headerHeight: headerHeight,
            horizontalPadding: horizontalPadding
        )
    }

    public static func subtitle(
        title: String,
        subtitle: String,
        headerHeight: CGFloat = 70,
        horizontalPadding: CGFloat = medium
    ) -> ScaffoldHeaderConfig {
        ScaffoldHeaderConfig(
            title: title,
            accessory: .subtitle(subtitle),
            headerHeight: headerHeight,
            horizontalPadding: horizontalPadding
        )
    }
}

// MARK: - ScaffoldView Protocol

public protocol ScaffoldView: View {
    associatedtype Content: View

    var background: ScaffoldBackground { get }
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    var emptyState: EmptyStateConfig? { get }
    var header: ScaffoldHeaderConfig? { get }

    @ViewBuilder var content: Content { get }
}

public extension ScaffoldView {
    var background: ScaffoldBackground { .canvas }
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
        if let config {
            self.scaffoldEmptyState(isEmpty, config: config)
        } else {
            self
        }
    }

    @ViewBuilder
    func applyHeader(config: ScaffoldHeaderConfig?) -> some View {
        if let config {
            self.scaffoldHeader(
                config.title,
                accessory: config.accessory,
                headerHeight: config.headerHeight,
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
            Text("ScaffoldView")
                .font(.title.weight(.black))
                .textCase(.uppercase)
            Text("Bauhaus background is automatic")
                .font(.caption)
        }
    }
}

private struct HeaderScreen: ScaffoldView {
    var header: ScaffoldHeaderConfig? {
        .chip(title: "My Words", chipLabel: "🔥 12", chipStyle: .warning)
    }

    var content: some View {
        VStack(spacing: mediumBig) {
            ForEach(0..<15) { index in
                Rectangle()
                    .fill(Color.surface)
                    .frame(height: 80)
                    .overlay(Rectangle().stroke(Color.border, lineWidth: borderThin))
                    .overlay(
                        Text("ITEM \(index + 1)")
                            .font(.caption.bold())
                            .tracking(2)
                            .foregroundStyle(.foreground)
                    )
            }
        }
    }
}

#Preview("Basic") {
    BasicScreen()
}

#Preview("Header") {
    HeaderScreen()
}

#Preview("Header Dark") {
    HeaderScreen().preferredColorScheme(.dark)
}
