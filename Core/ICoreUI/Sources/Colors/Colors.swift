//
//  Colors.swift
//  ICoreUI
//
//  Bauhaus design system — primary red/blue/yellow, foreground borders,
//  hard offset shadows, CEFR level accents (A1/A2/B1/B2).
//
//  AI Instructions:
//  - Demo: Core/ICoreUI/Example/Components/Foundations/ColorsDemo.swift
//    Update the `allColors` catalog there whenever a Color extension
//    is added/removed/renamed (and add it to NamedColor in
//    Example/Shared/DemoEnums.swift if it should be pickable from
//    other demos).
//

import SwiftUI

// MARK: - Color Hex Extension

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}

// MARK: - Adaptive Colors (Auto Light/Dark)

public extension Color {
    // Neutrals
    static let background = Color(.systemGroupedBackground)
    static let surface = adaptive(light: "#FFFFFF", dark: "#1E1E1E")
    static let foreground = adaptive(light: "#121212", dark: "#F0F0F0")
    static let foregroundMuted = adaptive(light: "#4A4A4A", dark: "#A0A0A0")
    static let muted = adaptive(light: "#E0E0E0", dark: "#2A2A2A")
    static let border = adaptive(light: "#121212", dark: "#F0F0F0")
    static let shadow = adaptive(light: "#121212", dark: "#000000")

    // Primary Bauhaus colors
    static let primaryRed = adaptive(light: "#AA151B", dark: "#E63946")
    static let primaryBlue = Color.blue // adaptive(light: "#1040C0", dark: "#3A6FE0")
    static let primaryYellow = adaptive(light: "#F1BF00", dark: "#F5CC3A")

    // Primary green
    static let primaryGreen = Color(.systemGreen)
    static let onGreen = adaptive(light: "#FFFFFF", dark: "#FFFFFF")

    // On-color text
    static let onRed = adaptive(light: "#FFFFFF", dark: "#FFFFFF")
    static let onBlue = adaptive(light: "#FFFFFF", dark: "#FFFFFF")
    static let onYellow = adaptive(light: "#121212", dark: "#121212")

    // CEFR level accents
    static let levelA1 = primaryYellow
    static let levelA2 = primaryRed
    static let levelB1 = primaryBlue
    static let levelB2 = foreground

    private static func adaptive(light: String, dark: String) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        })
    }
}

// MARK: - Preview

private struct ColorsPreview: View {
    var body: some View {
        List {
            Section("Neutrals") {
                colorRow("background", color: .background)
                colorRow("surface", color: .surface)
                colorRow("foreground", color: .foreground)
                colorRow("foregroundMuted", color: .foregroundMuted)
                colorRow("muted", color: .muted)
                colorRow("border", color: .border)
                colorRow("shadow", color: .shadow)
            }

            Section("Primaries") {
                colorRow("primaryRed", color: .primaryRed)
                colorRow("primaryBlue", color: .primaryBlue)
                colorRow("primaryYellow", color: .primaryYellow)
                colorRow("primaryGreen", color: .primaryGreen)
            }

            Section("On-Colors") {
                colorRow("onRed", color: .onRed)
                colorRow("onBlue", color: .onBlue)
                colorRow("onYellow", color: .onYellow)
                colorRow("onGreen", color: .onGreen)
            }

            Section("CEFR Levels") {
                colorRow("levelA1", color: .levelA1)
                colorRow("levelA2", color: .levelA2)
                colorRow("levelB1", color: .levelB1)
                colorRow("levelB2", color: .levelB2)
            }
        }
    }

    private func colorRow(_ name: String, color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(.quaternary, lineWidth: 1)
                )
            Text(name)
                .font(.body)
        }
    }
}

#Preview("Light") {
    ColorsPreview().preferredColorScheme(.light)
}

#Preview("Dark") {
    ColorsPreview().preferredColorScheme(.dark)
}
