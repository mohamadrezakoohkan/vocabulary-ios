//
//  CardStyle.swift
//  ICoreUI
//
//  Cards with continuous corners, soft shadows, and subtle borders.
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Styles/CardStyleDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever a parameter on `cardStyle(...)` / `CardModifier` is
//    added, removed, or renamed.
//

import SwiftUI

// MARK: - Card Modifier

public struct CardModifier: ViewModifier {
    private let paddingHorizontal: CGFloat
    private let paddingVertical: CGFloat
    private let backgroundColor: Color
    private let borderColor: Color?
    private let borderWidth: CGFloat
    private let cornerStyle: CornerStyle
    private let shadow: ShadowSize?

    public init(
        paddingHorizontal: CGFloat = medium,
        paddingVertical: CGFloat = smallMedium,
        backgroundColor: Color = .surface,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerStyle: CornerStyle = .medium,
        shadow: ShadowSize? = nil
    ) {
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerStyle = cornerStyle
        self.shadow = shadow
    }

    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(backgroundColor)
            .clipCornerStyle(cornerStyle)
            .overlay {
                if let borderColor {
                    if cornerStyle.isCapsule {
                        Capsule().stroke(borderColor, lineWidth: borderWidth)
                    } else {
                        RoundedRectangle(cornerRadius: cornerStyle.radius, style: .continuous)
                            .stroke(borderColor, lineWidth: borderWidth)
                    }
                }
            }
            .if(shadow != nil) { view in
                view.softShadow(shadow ?? .medium)
            }
    }
}

// MARK: - View Extension

public extension View {
    func cardStyle(
        paddingHorizontal: CGFloat = medium,
        paddingVertical: CGFloat = smallMedium,
        backgroundColor: Color = .surface,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerStyle: CornerStyle = .medium,
        shadow: ShadowSize? = nil
    ) -> some View {
        modifier(CardModifier(
            paddingHorizontal: paddingHorizontal,
            paddingVertical: paddingVertical,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerStyle: cornerStyle,
            shadow: shadow
        ))
    }
}

// MARK: - Preview

private struct CardStylePreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: medium) {
                VStack(alignment: .leading, spacing: small) {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("Surface background with a soft shadow.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle(shadow: .medium)

                VStack(alignment: .leading, spacing: small) {
                    Text("A1 — Beginner")
                        .font(.headline)
                    Text("Yellow accent card.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.onYellow)
                .cardStyle(
                    backgroundColor: .primaryYellow,
                    shadow: .medium
                )

                VStack(alignment: .leading, spacing: small) {
                    Text("A2 — Elementary")
                        .font(.headline)
                    Text("Red accent card.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.onRed)
                .cardStyle(
                    backgroundColor: .primaryRed,
                    shadow: .medium
                )

                VStack(alignment: .leading, spacing: small) {
                    Text("B1 — Intermediate")
                        .font(.headline)
                    Text("Blue accent card.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.onBlue)
                .cardStyle(
                    backgroundColor: .primaryBlue,
                    shadow: .medium
                )

                VStack(alignment: .leading, spacing: small) {
                    Text("Success")
                        .font(.headline)
                    Text("Green accent card.")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.onGreen)
                .cardStyle(
                    backgroundColor: .primaryGreen,
                    shadow: .medium
                )
            }
            .padding(medium)
        }
        .background(Color.background)
    }
}

#Preview("Light") {
    CardStylePreview().preferredColorScheme(.light)
}

#Preview("Dark") {
    CardStylePreview().preferredColorScheme(.dark)
}
