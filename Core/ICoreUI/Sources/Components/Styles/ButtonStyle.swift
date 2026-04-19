//
//  ButtonStyle.swift
//  ICoreUI
//
//  App button styles — filled, tinted, bordered, and plain variants
//  following Apple HIG with smooth spring animations.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Styles/ButtonStyleDemo.swift
//    Update the Interactive controls, ButtonVariant.pickables in
//    Example/Shared/DemoEnums.swift, and the Combinations gallery
//    there whenever a variant, corner option, or AppButtonStyle
//    parameter changes.
//

import SwiftUI

// MARK: - Button Variant

public enum ButtonVariant {
    /// Primary action — filled with primary color.
    case primary
    /// Secondary action — filled with blue.
    case secondary
    /// Tertiary — bordered outline style.
    case tertiary
    /// Ghost — plain text, no background.
    case ghost
    /// Accent — filled with yellow.
    case accent
    /// Info — filled with blue (alias).
    case info
    /// Warning — filled with yellow (alias).
    case warning
    /// Danger — filled with red (alias).
    case danger
}

// MARK: - Color Resolution

public extension ButtonVariant {
    var contentColor: Color {
        switch self {
        case .primary, .danger:          return .onRed
        case .secondary, .info:          return .onBlue
        case .accent, .warning:          return .onYellow
        case .tertiary:                  return .primaryRed
        case .ghost:                     return .primaryRed
        }
    }

    var backgroundColor: Color {
        switch self {
        case .primary, .danger:          return .primaryRed
        case .secondary, .info:          return .primaryBlue
        case .accent, .warning:          return .primaryYellow
        case .tertiary:                  return .clear
        case .ghost:                     return .clear
        }
    }

    var borderColor: Color {
        switch self {
        case .tertiary: return .primaryRed.opacity(0.3)
        default:        return .clear
        }
    }

    var hasBorder: Bool {
        self == .tertiary
    }
}

// MARK: - AppButtonStyle

public struct AppButtonStyle: ButtonStyle {
    private let variant: ButtonVariant
    private let cornerStyle: CornerStyle
    private let isFullWidth: Bool

    public init(
        variant: ButtonVariant = .primary,
        cornerStyle: CornerStyle = .medium,
        isFullWidth: Bool = false
    ) {
        self.variant = variant
        self.cornerStyle = cornerStyle
        self.isFullWidth = isFullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(variant.contentColor)
            .padding(.horizontal, medium)
            .padding(.vertical, smallMedium)
            .frame(minHeight: 44)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(variant.backgroundColor)
            .clipCornerStyle(cornerStyle)
            .overlay {
                if variant.hasBorder {
                    if cornerStyle.isCapsule {
                        Capsule().stroke(variant.borderColor, lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: cornerStyle.radius, style: .continuous)
                            .stroke(variant.borderColor, lineWidth: 1.5)
                    }
                }
            }
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - ButtonStyle Convenience

public extension ButtonStyle where Self == AppButtonStyle {
    static var appPrimary: AppButtonStyle    { AppButtonStyle(variant: .primary) }
    static var appSecondary: AppButtonStyle  { AppButtonStyle(variant: .secondary) }
    static var appTertiary: AppButtonStyle   { AppButtonStyle(variant: .tertiary) }
    static var appGhost: AppButtonStyle      { AppButtonStyle(variant: .ghost) }
    static var appAccent: AppButtonStyle     { AppButtonStyle(variant: .accent) }
    static var appInfo: AppButtonStyle       { AppButtonStyle(variant: .info) }
    static var appWarning: AppButtonStyle    { AppButtonStyle(variant: .warning) }
    static var appDanger: AppButtonStyle     { AppButtonStyle(variant: .danger) }

    static func app(
        variant: ButtonVariant,
        cornerStyle: CornerStyle = .medium,
        isFullWidth: Bool = false
    ) -> AppButtonStyle {
        AppButtonStyle(variant: variant, cornerStyle: cornerStyle, isFullWidth: isFullWidth)
    }
}

// MARK: - Preview

private struct ButtonStylePreview: View {
    var body: some View {
        List {
            Section("Filled") {
                Button("Primary") {}.buttonStyle(.appPrimary)
                Button("Secondary") {}.buttonStyle(.appSecondary)
                Button("Accent") {}.buttonStyle(.appAccent)
                Button("Danger") {}.buttonStyle(.appDanger)
            }

            Section("Outlined & Plain") {
                Button("Tertiary") {}.buttonStyle(.appTertiary)
                Button("Ghost") {}.buttonStyle(.appGhost)
            }

            Section("Capsule") {
                Button("Primary Pill") {}
                    .buttonStyle(.app(variant: .primary, cornerStyle: .capsule))
                Button("Accent Pill") {}
                    .buttonStyle(.app(variant: .accent, cornerStyle: .capsule))
            }

            Section("Full Width") {
                Button("Full Width Primary") {}
                    .buttonStyle(.app(variant: .primary, isFullWidth: true))
                Button("Full Width Secondary") {}
                    .buttonStyle(.app(variant: .secondary, cornerStyle: .capsule, isFullWidth: true))
            }

            Section("Disabled") {
                Button("Primary") {}.buttonStyle(.appPrimary).disabled(true)
                Button("Ghost") {}.buttonStyle(.appGhost).disabled(true)
            }
        }
    }
}

#Preview("Light") {
    ButtonStylePreview().preferredColorScheme(.light)
}

#Preview("Dark") {
    ButtonStylePreview().preferredColorScheme(.dark)
}
