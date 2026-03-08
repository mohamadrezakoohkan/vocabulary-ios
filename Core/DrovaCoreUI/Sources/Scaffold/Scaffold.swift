//
//  Scaffold.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - ScaffoldView Protocol

/// A protocol for views that automatically get themed scaffold features applied.
///
/// Conform to `ScaffoldView` instead of `View` and implement `content` instead of `body`.
/// The scaffold background, loading overlay, and empty state are applied automatically.
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
    
    @ViewBuilder var content: Content { get }
}

// MARK: - Default Implementations

public extension ScaffoldView {
    var background: ScaffoldBackground { .background1 }
    var isLoading: Bool { false }
    var isEmpty: Bool { false }
    var emptyState: EmptyStateConfig? { nil }

    @ViewBuilder
    var body: some View {
        content
            .applyEmptyState(isEmpty: isEmpty, config: emptyState)
            .scaffoldLoading(isLoading)
            .scaffoldBackground(background)
    }
}

// MARK: - Private Helper

private extension View {
    @ViewBuilder
    func applyEmptyState(isEmpty: Bool, config: EmptyStateConfig?) -> some View {
        if let config = config {
            self.scaffoldEmptyState(isEmpty, config: config)
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
#Preview("Basic") {
    BasicScreen()
}

#Preview("Loading") {
    LoadingScreen()
}

#Preview("Empty State") {
    EmptyScreen()
}

