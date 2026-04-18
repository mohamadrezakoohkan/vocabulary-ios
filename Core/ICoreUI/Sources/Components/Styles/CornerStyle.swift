//
//  CornerStyle.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Corner Style

public enum CornerStyle {
    case rounded(CGFloat)
    case capsule
    
    var isCapsule: Bool {
        if case .capsule = self { return true }
        return false
    }
    
    var radius: CGFloat {
        switch self {
        case .rounded(let r): return r
        case .capsule: return 999
        }
    }
}

// MARK: - Corner Style Helper

public extension View {
    @ViewBuilder
    func clipCornerStyle(_ style: CornerStyle) -> some View {
        if style.isCapsule {
            self.clipShape(Capsule())
        } else {
            self.clipShape(RoundedRectangle(cornerRadius: style.radius))
        }
    }
}
