//
//  ButtonStyle.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Button Variant

/// Defines the visual style variants for buttons
public enum ButtonVariant {
    /// Primary action button with gradient background
    case primary
    /// Secondary button with fill
    case secondary
    /// Tertiary button with border, no fill
    case tertiary
    /// Ghost button - text only, no background or border
    case ghost
    /// Accent style button (non-gradient)
    case accent
    /// Informational style button
    case info
    /// Warning style button
    case warning
    /// Danger/error style button
    case danger
}

// MARK: - Color Resolution

public extension ButtonVariant {
    /// Returns the content/foreground color for this variant
    func contentColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .primary:
            return theme.buttonContent
        case .secondary, .tertiary, .ghost:
            return theme.content1
        case .accent:
            return theme.accentContent
        case .info:
            return theme.alertInfoContent
        case .warning:
            return theme.alertWarningContent
        case .danger:
            return theme.alertDangerContent
        }
    }
    
    /// Returns the background color for this variant
    func backgroundColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .primary:
            return .clear // Uses gradient instead
        case .secondary:
            return theme.background3
        case .tertiary, .ghost:
            return .clear
        case .accent:
            return theme.accentBackground
        case .info:
            return theme.alertInfoBackground
        case .warning:
            return theme.alertWarningBackground
        case .danger:
            return theme.alertDangerBackground
        }
    }
    
    /// Returns the border color for this variant
    func borderColor(for theme: any ColorTheme) -> Color {
        switch self {
        case .primary, .secondary, .ghost:
            return .clear
        case .tertiary:
            return theme.border1
        case .accent:
            return theme.accentBorder
        case .info:
            return theme.alertInfoBorder
        case .warning:
            return theme.alertWarningBorder
        case .danger:
            return theme.alertDangerBorder
        }
    }
    
    /// Returns whether this variant uses a gradient background
    var usesGradient: Bool {
        self == .primary
    }
    
    /// Returns the gradient for this variant (only applicable for primary)
    func gradient(for theme: any ColorTheme) -> LinearGradient {
        theme.buttonGradient
    }
    
    /// Returns the shadow color for this variant
    func shadowColor(for theme: any ColorTheme, isEnabled: Bool) -> Color {
        switch self {
        case .primary:
            return theme.buttonBackgroundStart.opacity(isEnabled ? 0.4 : 0)
        default:
            return .clear
        }
    }
    
    /// Returns the disabled opacity for this variant
    var disabledOpacity: Double {
        switch self {
        case .primary, .accent, .info, .warning, .danger:
            return 0.6
        case .secondary, .tertiary, .ghost:
            return 0.5
        }
    }
}

// MARK: - Button Modifier

public struct ButtonModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    
    private let variant: ButtonVariant
    private let cornerStyle: CornerStyle
    
    private var theme: any ColorTheme {
        colorScheme.theme
    }
    
    public init(
        variant: ButtonVariant = .primary,
        cornerStyle: CornerStyle = .rounded(smallMedium)
    ) {
        self.variant = variant
        self.cornerStyle = cornerStyle
    }
    
    public func body(content: Content) -> some View {
        content
            .foregroundStyle(variant.contentColor(for: theme))
            .padding(.horizontal, medium)
            .padding(.vertical, smallMedium)
            .background {
                if variant.usesGradient {
                    variant.gradient(for: theme)
                } else {
                    variant.backgroundColor(for: theme)
                }
            }
            .clipCornerStyle(cornerStyle)
            .overlay {
                RoundedRectangle(cornerRadius: cornerStyle.radius)
                    .strokeBorder(variant.borderColor(for: theme).opacity(isEnabled ? 1 : 0.4), lineWidth: 1)
            }
            .shadow(
                color: variant.shadowColor(for: theme, isEnabled: isEnabled),
                radius: 8,
                x: 0,
                y: 4
            )
            .opacity(isEnabled ? 1.0 : variant.disabledOpacity)
    }
}


// MARK: - View Extension

public extension View {
    /// Applies button styling to any view
    func buttonStyle(
        variant: ButtonVariant = .primary,
        cornerStyle: CornerStyle = .rounded(smallMedium)
    ) -> some View {
        modifier(ButtonModifier(
            variant: variant,
            cornerStyle: cornerStyle
        ))
    }
}

// MARK: - SwiftUI ButtonStyle

/// A SwiftUI ButtonStyle conformant that applies app styling
public struct AppButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    private let variant: ButtonVariant
    private let cornerStyle: CornerStyle
    
    private var theme: any ColorTheme {
        colorScheme.theme
    }
    
    public init(
        variant: ButtonVariant = .primary,
        cornerStyle: CornerStyle = .rounded(smallMedium)
    ) {
        self.variant = variant
        self.cornerStyle = cornerStyle
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .buttonStyle(variant: variant, cornerStyle: cornerStyle)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - ButtonStyle Extension

public extension ButtonStyle where Self == AppButtonStyle {
    static var appPrimary: AppButtonStyle {
        AppButtonStyle(variant: .primary)
    }
    
    static var appSecondary: AppButtonStyle {
        AppButtonStyle(variant: .secondary)
    }

    static var appTertiary: AppButtonStyle {
        AppButtonStyle(variant: .tertiary)
    }

    static var appGhost: AppButtonStyle {
        AppButtonStyle(variant: .ghost)
    }
    
    static var appAccent: AppButtonStyle {
        AppButtonStyle(variant: .accent)
    }
    
    static var appInfo: AppButtonStyle {
        AppButtonStyle(variant: .info)
    }
    
    static var appWarning: AppButtonStyle {
        AppButtonStyle(variant: .warning)
    }
    
    static var appDanger: AppButtonStyle {
        AppButtonStyle(variant: .danger)
    }
    
    static func app(
        variant: ButtonVariant,
        cornerStyle: CornerStyle = .rounded(smallMedium)
    ) -> AppButtonStyle {
        AppButtonStyle(variant: variant, cornerStyle: cornerStyle)
    }
}

// MARK: - Preview

private struct ButtonStylePreview: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: medium) {
                // Primary buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Primary")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button("Button") {}
                            .buttonStyle(.appPrimary)

                        Button("Capsule") {}
                            .buttonStyle(.app(variant: .primary, cornerStyle: .capsule))

                        Button("Disabled") {}
                            .buttonStyle(.appPrimary)
                            .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Alert style buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Alert Styles")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button("Accent") {}
                            .buttonStyle(.appAccent)

                        Button("Info") {}
                            .buttonStyle(.appInfo)

                        Button("Warning") {}
                            .buttonStyle(.appWarning)

                        Button("Danger") {}
                            .buttonStyle(.appDanger)
                    }
                    
                    HStack {
                        Button("Accent") {}
                            .buttonStyle(.appAccent)
                            .disabled(true)

                        Button("Info") {}
                            .buttonStyle(.appInfo)
                            .disabled(true)

                        Button("Warning") {}
                            .buttonStyle(.appWarning)
                            .disabled(true)

                        Button("Danger") {}
                            .buttonStyle(.appDanger)
                            .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Secondary buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Secondary")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button("Button") {}
                            .buttonStyle(.appSecondary)

                        Button("Capsule") {}
                            .buttonStyle(.app(variant: .secondary, cornerStyle: .capsule))

                        Button("Disabled") {}
                            .buttonStyle(.appSecondary)
                            .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Ghost buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Ghost")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button("Ghost Button") {}
                            .buttonStyle(.appGhost)

                        Button("Ghost Disabled") {}
                            .buttonStyle(.appGhost)
                            .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Button with icons
                VStack(alignment: .leading, spacing: small) {
                    Text("With Icons")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button {
                        } label: {
                            HStack(spacing: small) {
                                Icon(iconName: "plus.circle.fill")
                                Text("Add Item")
                            }
                        }
                        .buttonStyle(.appPrimary)

                        Button {
                        } label: {
                            HStack(spacing: small) {
                                Image(systemName: "trash.fill")
                                Text("Delete")
                            }
                        }
                        .buttonStyle(.appDanger)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Full width buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Full Width")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    Button {
                    } label: {
                        Text("Primary")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appPrimary)

                    Button {
                    } label: {
                        Text("Ghost")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appGhost)

                    Button {
                    } label: {
                        Text("Secondary")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appSecondary)

                    Button {
                    } label: {
                        Text("Tertiary")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appTertiary)

                    Button {
                    } label: {
                        Text("Accent")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appAccent)

                    Button {
                    } label: {
                        Text("Info")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appInfo)

                    Button {
                    } label: {
                        Text("Warning")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appWarning)

                    Button {
                    } label: {
                        Text("Danger")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appDanger)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Vertical layout buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Vertical Layout")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    HStack(spacing: smallMedium) {
                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "leaf.fill")
                                    .font(.title)
                                Text("Evolve")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appAccent)

                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "moon.zzz.fill")
                                    .font(.title)
                                Text("Rest")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appWarning)

                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "archivebox.fill")
                                    .font(.title)
                                Text("Archive")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appDanger)
                    }
                    
                    HStack(spacing: smallMedium) {
                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                Text("Primary")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appPrimary)

                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "info.circle.fill")
                                    .font(.title2)
                                Text("Info")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appInfo)

                        Button {
                        } label: {
                            VStack(spacing: small) {
                                Image(systemName: "gearshape.fill")
                                    .font(.title2)
                                Text("Secondary")
                            }
                            .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.appSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .background(colors.background1)
    }
}

#Preview("Light Mode") {
    ButtonStylePreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ButtonStylePreview()
        .preferredColorScheme(.dark)
}
