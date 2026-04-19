//
//  Shadow.swift
//  ICoreUI
//
//  Soft diffused shadows following Apple HIG.
//

import SwiftUI

public enum ShadowSize {
    /// Subtle lift — inputs, chips.
    case small
    /// Default card elevation.
    case medium
    /// Prominent elevation — modals, hero cards.
    case large

    var radius: CGFloat {
        switch self {
        case .small:  return 4
        case .medium: return 8
        case .large:  return 16
        }
    }

    var y: CGFloat {
        switch self {
        case .small:  return 2
        case .medium: return 4
        case .large:  return 8
        }
    }
}

public extension View {
    /// Applies a soft diffused shadow.
    func softShadow(
        _ size: ShadowSize = .medium,
        color: Color = .black.opacity(0.08)
    ) -> some View {
        self.shadow(
            color: color,
            radius: size.radius,
            x: 0,
            y: size.y
        )
    }
}
