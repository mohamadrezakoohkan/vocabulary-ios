//
//  ScaffoldBackgroundModifier.swift
//  ICoreUI
//

import SwiftUI

/// Background level for screen scaffolding.
public enum ScaffoldBackground {
    /// Canvas (`Color.background`).
    case canvas
    /// Elevated surface (`Color.surface`).
    case surface
    /// Muted divider-level surface (`Color.muted`).
    case muted
    /// Inverse — uses `Color.foreground` as bg (for hero color-blocked screens).
    case inverse

    var color: Color {
        switch self {
        case .canvas:  return .background
        case .surface: return .surface
        case .muted:   return .muted
        case .inverse: return .foreground
        }
    }
}

struct ScaffoldBackgroundModifier: ViewModifier {
    let background: ScaffoldBackground

    func body(content: Content) -> some View {
        ZStack {
            background.color.ignoresSafeArea()
            content
        }
    }
}

public extension View {
    /// Wraps this view in a scaffold with the themed background.
    /// - Parameter background: The background level to use. Defaults to `.canvas`.
    func scaffoldBackground(_ background: ScaffoldBackground = .canvas) -> some View {
        modifier(ScaffoldBackgroundModifier(background: background))
    }
}

#Preview("Canvas") {
    Text("Canvas").scaffoldBackground(.canvas)
}

#Preview("Surface") {
    Text("Surface").scaffoldBackground(.surface)
}

#Preview("Muted") {
    Text("Muted").scaffoldBackground(.muted)
}

#Preview("Inverse") {
    Text("Inverse").foregroundStyle(.white).scaffoldBackground(.inverse)
}
