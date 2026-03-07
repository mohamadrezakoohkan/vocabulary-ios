//
//  CardStyle.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Card Modifier

public struct CardModifier: ViewModifier {
    private let paddingHorizontal: CGFloat
    private let paddingVertical: CGFloat
    private let backgroundColor: Color
    private let borderColor: Color?
    private let cornerStyle: CornerStyle
    
    public init(
        paddingHorizontal: CGFloat = medium,
        paddingVertical: CGFloat = smallMedium,
        backgroundColor: Color = .clear,
        borderColor: Color? = nil,
        cornerStyle: CornerStyle = .rounded(small)
    ) {
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerStyle = cornerStyle
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(backgroundColor)
            .if(cornerStyle.isCapsule, then: { view in
                view.clipShape(Capsule())
                    .ifLet(borderColor) { v, color in
                        v.overlay(Capsule().stroke(color, lineWidth: 1))
                    }
            }, else: { view in
                view.clipShape(RoundedRectangle(cornerRadius: cornerStyle.radius))
                    .ifLet(borderColor) { v, color in
                        v.overlay(
                            RoundedRectangle(cornerRadius: cornerStyle.radius)
                                .stroke(color, lineWidth: 1)
                        )
                    }
            })
    }
}

// MARK: - View Extension

public extension View {
    func cardStyle(
        paddingHorizontal: CGFloat = medium,
        paddingVertical: CGFloat = smallMedium,
        backgroundColor: Color = .clear,
        borderColor: Color? = nil,
        cornerStyle: CornerStyle = .rounded(small)
    ) -> some View {
        modifier(CardModifier(
            paddingHorizontal: paddingHorizontal,
            paddingVertical: paddingVertical,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerStyle: cornerStyle
        ))
    }
}

// MARK: - Preview

private struct CardStylePreview: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: medium) {
                // Info Alert
                HStack(spacing: small) {
                    Image(systemName: "info.circle.fill")
                    Text("This is an info message")
                    Spacer()
                }
                .foregroundStyle(colors.alertInfoContent)
                .cardStyle(
                    backgroundColor: colors.alertInfoBackground,
                    borderColor: colors.alertInfoBorder,
                    cornerStyle: .rounded(smallMedium)
                )
                
                // Danger Alert
                HStack(spacing: small) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("This is a danger message")
                    Spacer()
                }
                .foregroundStyle(colors.alertDangerContent)
                .cardStyle(
                    backgroundColor: colors.alertDangerBackground,
                    borderColor: colors.alertDangerBorder,
                    cornerStyle: .rounded(smallMedium)
                )
                
                // Warning Alert
                HStack(spacing: small) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("This is a warning message")
                    Spacer()
                }
                .foregroundStyle(colors.alertWarningContent)
                .cardStyle(
                    backgroundColor: colors.alertWarningBackground,
                    borderColor: colors.alertWarningBorder,
                    cornerStyle: .rounded(smallMedium)
                )
                
                // Capsule style tags
                HStack(spacing: small) {
                    Text("Info")
                        .font(.caption)
                        .foregroundStyle(colors.alertInfoContent)
                        .cardStyle(
                            paddingHorizontal: smallMedium,
                            paddingVertical: extraSmall,
                            backgroundColor: colors.alertInfoBackground,
                            borderColor: colors.alertInfoBorder,
                            cornerStyle: .capsule
                        )
                    
                    Text("Danger")
                        .font(.caption)
                        .foregroundStyle(colors.alertDangerContent)
                        .cardStyle(
                            paddingHorizontal: smallMedium,
                            paddingVertical: extraSmall,
                            backgroundColor: colors.alertDangerBackground,
                            borderColor: colors.alertDangerBorder,
                            cornerStyle: .capsule
                        )
                    
                    Text("Warning")
                        .font(.caption)
                        .foregroundStyle(colors.alertWarningContent)
                        .cardStyle(
                            paddingHorizontal: smallMedium,
                            paddingVertical: extraSmall,
                            backgroundColor: colors.alertWarningBackground,
                            borderColor: colors.alertWarningBorder,
                            cornerStyle: .capsule
                        )
                    
                    Spacer()
                }
                
                // Accent card
                VStack(alignment: .leading, spacing: small) {
                    Text("Accent Card")
                        .font(.headline)
                    Text("This card uses accent colors from the theme.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(colors.accentContent)
                .cardStyle(
                    backgroundColor: colors.accentBackground,
                    borderColor: colors.accentBorder,
                    cornerStyle: .rounded(medium)
                )
                
                // Simple bordered card
                VStack(alignment: .leading, spacing: small) {
                    Text("Bordered Card")
                        .font(.headline)
                    Text("A simple card with border only.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(colors.content1)
                .cardStyle(
                    backgroundColor: colors.background2,
                    borderColor: colors.border1,
                    cornerStyle: .rounded(medium)
                )
            }
            .padding()
        }
        .background(colors.background1)
    }
}
#Preview("Light Mode") {
    CardStylePreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CardStylePreview()
        .preferredColorScheme(.dark)
}

