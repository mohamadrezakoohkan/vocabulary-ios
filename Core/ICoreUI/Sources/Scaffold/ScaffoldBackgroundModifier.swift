//
//  ScaffoldBackgroundModifier.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI

// MARK: - Background Level

/// The background level to use for the scaffold.
public enum ScaffoldBackground {
    case background1
    case background2
    case background3
    case backgroundInverse
    
    func color(for theme: any ColorTheme) -> Color {
        switch self {
        case .background1:
            return theme.background1
        case .background2:
            return theme.background2
        case .background3:
            return theme.background3
        case .backgroundInverse:
            return theme.backgroundInverse
        }
    }
}

// MARK: - Scaffold Background Modifier

/// A view modifier that applies the themed background to any view.
struct ScaffoldBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let background: ScaffoldBackground
    
    func body(content: Content) -> some View {
        ZStack {
            background.color(for: colorScheme.theme)
                .ignoresSafeArea()
            content
        }
    }
}

// MARK: - View Extension

extension View {
    /// Wraps this view in a scaffold with the themed background.
    ///
    /// - Parameter background: The background level to use. Defaults to `.background1`.
    ///
    /// ```swift
    /// struct MyScreen: View {
    ///     var body: some View {
    ///         VStack {
    ///             Text("Hello")
    ///         }
    ///         .scaffoldBackground()  // uses background1
    ///         // or
    ///         .scaffoldBackground(.background2)
    ///     }
    /// }
    /// ```
    func scaffoldBackground(_ background: ScaffoldBackground = .background1) -> some View {
        modifier(ScaffoldBackgroundModifier(background: background))
    }
}

// MARK: - Preview

#Preview("Background 1") {
    Text("Background 1")
        .scaffoldBackground(.background1)
}

#Preview("Background 2") {
    Text("Background 2")
        .scaffoldBackground(.background2)
}

#Preview("Background 3") {
    Text("Background 3")
        .scaffoldBackground(.background3)
}

#Preview("Background Inverse") {
    Text("Background Inverse")
        .foregroundStyle(Color.red)
        .scaffoldBackground(.backgroundInverse)
}
