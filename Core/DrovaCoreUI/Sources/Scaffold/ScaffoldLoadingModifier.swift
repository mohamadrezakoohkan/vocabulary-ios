//
//  ScaffoldLoadingModifier.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Loading Modifier

/// A view modifier that displays a loading overlay on top of content.
struct ScaffoldLoadingModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                LoadingOverlayView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Loading Overlay View

private struct LoadingOverlayView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            colorScheme.theme.background1
                .opacity(0.8)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
                .tint(colorScheme.theme.accentPrimary)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Displays a loading overlay on top of the view.
    ///
    /// - Parameter isLoading: Whether to show the loading overlay.
    ///
    /// ```swift
    /// MyContentView()
    ///     .scaffoldLoading(viewModel.isLoading)
    /// ```
    func scaffoldLoading(_ isLoading: Bool) -> some View {
        modifier(ScaffoldLoadingModifier(isLoading: isLoading))
    }
}

// MARK: - Preview

private struct LoadingPreview: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Content underneath")
                Text("Content underneath")
                Text("Content underneath")
                Text("Content underneath")
            }
            .scaffoldBackground()
            .scaffoldLoading(isLoading)
            Button("Toggle Loading") {
                isLoading.toggle()
            }
            .buttonStyle(.appGhost)
        }
    }
}

#Preview {
    LoadingPreview()
}
