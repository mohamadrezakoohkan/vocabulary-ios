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
    /// Destructive/danger action button
    case destructive
    /// Ghost button - text only, no background or border
    case ghost
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
        switch variant {
        case .primary:
            content
                .foregroundStyle(theme.buttonContent)
                .padding(.horizontal, medium)
                .padding(.vertical, smallMedium)
                .background(theme.buttonGradient)
                .clipCornerStyle(cornerStyle)
                .shadow(color: theme.buttonBackgroundStart.opacity(isEnabled ? 0.4 : 0), radius: 8, x: 0, y: 4)
                .opacity(isEnabled ? 1.0 : 0.6)

        case .secondary:
            content
                .foregroundStyle(theme.content1)
                .cardStyle(
                    paddingHorizontal: medium,
                    paddingVertical: smallMedium,
                    backgroundColor: theme.background3,
                    cornerStyle: cornerStyle
                )
                .opacity(isEnabled ? 1.0 : 0.5)
        case .tertiary:
            content
                .foregroundStyle(theme.content1)
                .cardStyle(
                    paddingHorizontal: medium,
                    paddingVertical: smallMedium,
                    borderColor: theme.border1,
                    cornerStyle: cornerStyle
                )
                .opacity(isEnabled ? 1.0 : 0.5)

        case .destructive:
            content
                .foregroundStyle(theme.alertDangerContent)
                .cardStyle(
                    paddingHorizontal: medium,
                    paddingVertical: smallMedium,
                    backgroundColor: theme.alertDangerBackground,
                    borderColor: theme.alertDangerBorder.opacity(isEnabled ? 1 : 0.4),
                    cornerStyle: cornerStyle
                )
                .opacity(isEnabled ? 1.0 : 0.6)

        case .ghost:
            content
                .foregroundStyle(theme.content1)
                .padding(.horizontal, medium)
                .padding(.vertical, smallMedium)
                .opacity(isEnabled ? 1.0 : 0.5)
        }
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
    
    static var appDestructive: AppButtonStyle {
        AppButtonStyle(variant: .destructive)
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
                
                // Destructive buttons
                VStack(alignment: .leading, spacing: small) {
                    Text("Destructive")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)

                    HStack {
                        Button("Delete Item") {}
                            .buttonStyle(.appDestructive)

                        Button("Destructive Disabled") {}
                            .buttonStyle(.appDestructive)
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
                        .buttonStyle(.appDestructive)
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
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appPrimary)

                    Button {
                    } label: {
                        Text("Not now")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appGhost)

                    Button {
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appSecondary)

                    Button {
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appTertiary)
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
