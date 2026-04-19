//
//  CornerStyle.swift
//  ICoreUI
//
//  Apple HIG corner radii — smooth continuous corners.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Styles/CornerStyleDemo.swift
//    Update the Interactive controls, CornerStyle.pickables in
//    Example/Shared/DemoEnums.swift, and the Combinations gallery
//    there whenever a preset case or radius mapping changes.
//

import SwiftUI

public enum CornerStyle {
    /// Small radius (8pt) — badges, chips, compact elements.
    case small
    /// Medium radius (12pt) — default for cards, inputs, buttons.
    case medium
    /// Large radius (16pt) — prominent cards, modals.
    case large
    /// Fully rounded pill / capsule shape.
    case capsule
    /// Custom explicit radius.
    case custom(CGFloat)

    var isCapsule: Bool {
        if case .capsule = self { return true }
        return false
    }

    var radius: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .capsule: return 999
        case .custom(let r): return r
        }
    }
}

public extension View {
    @ViewBuilder
    func clipCornerStyle(_ style: CornerStyle) -> some View {
        if style.isCapsule {
            self.clipShape(Capsule())
        } else {
            self.clipShape(RoundedRectangle(cornerRadius: style.radius, style: .continuous))
        }
    }
}
