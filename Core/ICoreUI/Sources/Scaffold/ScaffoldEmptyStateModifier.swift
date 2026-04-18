//
//  ScaffoldEmptyStateModifier.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Empty State Configuration

/// Configuration for the empty state view.
public struct EmptyStateConfig {
    public let icon: Icons
    public let title: String
    public let message: String?
    public let actionTitle: String?
    public let action: (() -> Void)?
    
    public init(
        icon: Icons,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
}

// MARK: - Empty State Modifier

/// A view modifier that shows an empty state when content is empty.
struct ScaffoldEmptyStateModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let isEmpty: Bool
    let config: EmptyStateConfig
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(isEmpty ? 0 : 1)
            
            if isEmpty {
                EmptyStateView(config: config)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isEmpty)
    }
}

// MARK: - Empty State View

private struct EmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let config: EmptyStateConfig
    
    private var theme: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(spacing: medium) {
            Icon(config.icon, size: .custom(extraBig))
                .foregroundStyle(theme.content2)
            
            VStack(spacing: small) {
                Text(config.title)
                    .font(.headline)
                    .foregroundStyle(theme.content1)
                
                if let message = config.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(theme.content2)
                        .multilineTextAlignment(.center)
                }
            }
            
            if let actionTitle = config.actionTitle, let action = config.action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .buttonStyle(variant: .info, cornerStyle: .capsule)
                .padding(.top, small)
            }
        }
        .padding(big)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - View Extension

public extension View {
    /// Shows an empty state view when content is empty.
    ///
    /// - Parameters:
    ///   - isEmpty: Whether the content is empty.
    ///   - config: Configuration for the empty state appearance.
    ///
    /// ```swift
    /// List(items) { item in
    ///     ItemRow(item: item)
    /// }
    /// .scaffoldEmptyState(
    ///     items.isEmpty,
    ///     config: EmptyStateConfig(
    ///         icon: .leaf,
    ///         title: "No items yet",
    ///         message: "Start by adding your first item",
    ///         actionTitle: "Add Item",
    ///         action: { viewModel.addItem() }
    ///     )
    /// )
    /// ```
    func scaffoldEmptyState(_ isEmpty: Bool, config: EmptyStateConfig) -> some View {
        modifier(ScaffoldEmptyStateModifier(isEmpty: isEmpty, config: config))
    }
    
    /// Shows an empty state view when content is empty (simple version).
    ///
    /// - Parameters:
    ///   - isEmpty: Whether the content is empty.
    ///   - icon: The icon to display.
    ///   - title: The title text.
    ///   - message: Optional message text.
    func scaffoldEmptyState(
        _ isEmpty: Bool,
        icon: Icons,
        title: String,
        message: String? = nil
    ) -> some View {
        modifier(ScaffoldEmptyStateModifier(
            isEmpty: isEmpty,
            config: EmptyStateConfig(icon: icon, title: title, message: message)
        ))
    }
}

// MARK: - Preview

#Preview("Empty State") {
    VStack {
        // Empty content
    }
    .scaffoldBackground()
    .scaffoldEmptyState(
        true,
        config: EmptyStateConfig(
            icon: .leaf,
            title: "No memories yet",
            message: "Start capturing moments to see them here",
            actionTitle: "Capture Now",
            action: { print("Action tapped") }
        )
    )
}

#Preview("Empty State Simple") {
    VStack {
        // Empty content
    }
    .scaffoldBackground()
    .scaffoldEmptyState(
        true,
        icon: .magnifyingGlass,
        title: "No results found",
        message: "Try a different search term"
    )
}

#Preview("With Content") {
    VStack {
        Text("Content is here!")
    }
    .scaffoldBackground()
    .scaffoldEmptyState(
        false,
        icon: .leaf,
        title: "No items",
        message: "This won't show"
    )
}
