//
//  Colors.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

// MARK: - Color Theme Protocol

/// Protocol defining the color requirements for a theme
public protocol ColorTheme {
    // Content colors
    var content1: Color { get }
    var content2: Color { get }
    var contentInverse: Color { get }
    
    // Accent colors
    var accentContent: Color { get }
    var accentBackground: Color { get }
    var accentBorder: Color { get }
    
    // Background colors
    var background1: Color { get }
    var background2: Color { get }
    var background3: Color { get }
    var backgroundInverse: Color { get }
    
    // Border colors
    var border1: Color { get }
    var border2: Color { get }
    
    // Alert - Info
    var alertInfoContent: Color { get }
    var alertInfoBackground: Color { get }
    var alertInfoBorder: Color { get }
    
    // Alert - Danger
    var alertDangerContent: Color { get }
    var alertDangerBackground: Color { get }
    var alertDangerBorder: Color { get }
    
    // Alert - Warning
    var alertWarningContent: Color { get }
    var alertWarningBackground: Color { get }
    var alertWarningBorder: Color { get }
    
    // Button
    var buttonBackgroundStart: Color { get }
    var buttonBackgroundEnd: Color { get }
    var buttonContent: Color { get }
}

// MARK: - Light Theme

private struct LightTheme: ColorTheme {
    // Content
    var content1: Color { Color(hex: "#091B0A") }
    var content2: Color { Color(hex: "#6D7C6D") }
    var contentInverse: Color { Color(hex: "#071C0E") }
    
    // Accent
    var accentContent: Color { Color(hex: "#FFFFFF") }
    var accentBackground: Color { Color(hex: "#30D158") }
    var accentBorder: Color { Color(hex: "#28A745") }
    
    // Background
    var background1: Color { Color(hex: "#FFFFFF") }
    var background2: Color { Color(hex: "#F5F6F7") }
    var background3: Color { Color(hex: "#E7E9EB") }
    var backgroundInverse: Color { Color(hex: "#0E1410") }
    
    // Border
    var border1: Color { Color(hex: "#E7E9EB") }
    var border2: Color { Color(hex: "#CFD3D6") }
    
    // Alert - Info
    var alertInfoContent: Color { Color(hex: "#FFFFFF") }
    var alertInfoBackground: Color { Color(hex: "#708FFF") }
    var alertInfoBorder: Color { Color(hex: "#4F76FF") }
    
    // Alert - Danger
    var alertDangerContent: Color { Color(hex: "#FFFFFF") }
    var alertDangerBackground: Color { Color(hex: "#FF3B57") }
    var alertDangerBorder: Color { Color(hex: "#FF0024") }
    
    // Alert - Warning
    var alertWarningContent: Color { Color(hex: "#FFFFFF") }
    var alertWarningBackground: Color { Color(hex: "#FFB930") }
    var alertWarningBorder: Color { Color(hex: "#FFA900") }
    
    // Button
    var buttonBackgroundStart: Color { Color(hex: "#00DE3C") }
    var buttonBackgroundEnd: Color { Color(hex: "#00C358") }
    var buttonContent: Color { Color(hex: "#FFFFFF") }
}

// MARK: - Dark Theme

private struct DarkTheme: ColorTheme {
    // Content
    var content1: Color { Color(hex: "#FFFFFF") }
    var content2: Color { Color(hex: "#B1C4B1") }
    var contentInverse: Color { Color(hex: "#071C0E") }
    
    // Accent
    var accentContent: Color { Color(hex: "#00E275") }
    var accentBackground: Color { Color(hex: "#15261B") }
    var accentBorder: Color { Color(hex: "#0A4726") }
    
    // Background
    var background1: Color { Color(hex: "#141414") }
    var background2: Color { Color(hex: "#1A1A1A") }
    var background3: Color { Color(hex: "#232323") }
    var backgroundInverse: Color { Color(hex: "#FFFFFF") }
    
    // Border
    var border1: Color { Color(hex: "#262626") }
    var border2: Color { Color(hex: "#323232") }
    
    // Alert - Info
    var alertInfoContent: Color { Color(hex: "#5B9BFF") }
    var alertInfoBackground: Color { Color(hex: "#1E2D4D") }
    var alertInfoBorder: Color { Color(hex: "#2E4470") }
    
    // Alert - Danger
    var alertDangerContent: Color { Color(hex: "#FF666C") }
    var alertDangerBackground: Color { Color(hex: "#2E2021") }
    var alertDangerBorder: Color { Color(hex: "#492A29") }
    
    // Alert - Warning
    var alertWarningContent: Color { Color(hex: "#FFBD00") }
    var alertWarningBackground: Color { Color(hex: "#322B1B") }
    var alertWarningBorder: Color { Color(hex: "#52411B") }

    // Button
    var buttonBackgroundStart: Color { Color(hex: "#00DE3C") }
    var buttonBackgroundEnd: Color { Color(hex: "#00C358") }
    var buttonContent: Color { Color(hex: "#FFFFFF") }
}

// MARK: - ColorScheme Extension

public extension ColorScheme {
    /// Returns the current theme colors based on the color scheme
    var theme: any ColorTheme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        @unknown default:
            return LightTheme()
        }
    }
}

public extension Optional where Wrapped == ColorScheme {
    /// Returns the current theme colors, defaulting to light theme if nil
    var theme: any ColorTheme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        case .none:
            return LightTheme()
        @unknown default:
            return LightTheme()
        }
    }
}

// MARK: - Button Gradient Helper

public extension ColorTheme {
    /// Convenience gradient for buttons
    var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [buttonBackgroundStart, buttonBackgroundEnd],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Hex Extension

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
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

public extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
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

// MARK: - Preview

private struct ColorsPreview: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: medium) {
                Text("Current: \(colorScheme == .dark ? "Dark" : "Light") Mode")
                    .font(.headline)
                    .foregroundStyle(colors.content1)
                    .padding(.horizontal)
                
                colorSection(title: "Content", items: [
                    ("content1", colors.content1),
                    ("content2", colors.content2),
                    ("contentInverse", colors.contentInverse),
                ])
                
                colorSection(title: "Accent", items: [
                    ("accentContent", colors.accentContent),
                    ("accentBackground", colors.accentBackground),
                    ("accentBorder", colors.accentBorder),
                ])
                
                colorSection(title: "Background", items: [
                    ("background1", colors.background1),
                    ("background2", colors.background2),
                    ("background3", colors.background3),
                    ("backgroundInverse", colors.backgroundInverse),
                ])
                
                colorSection(title: "Border", items: [
                    ("border1", colors.border1),
                    ("border2", colors.border2),
                ])
                
                colorSection(title: "Alert - Info", items: [
                    ("alertInfoContent", colors.alertInfoContent),
                    ("alertInfoBackground", colors.alertInfoBackground),
                    ("alertInfoBorder", colors.alertInfoBorder),
                ])
                
                colorSection(title: "Alert - Danger", items: [
                    ("alertDangerContent", colors.alertDangerContent),
                    ("alertDangerBackground", colors.alertDangerBackground),
                    ("alertDangerBorder", colors.alertDangerBorder),
                ])
                
                colorSection(title: "Alert - Warning", items: [
                    ("alertWarningContent", colors.alertWarningContent),
                    ("alertWarningBackground", colors.alertWarningBackground),
                    ("alertWarningBorder", colors.alertWarningBorder),
                ])
                
                // Button with gradient
                VStack(alignment: .leading, spacing: small) {
                    Text("Button")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    Button(action: {}) {
                        Text("Button Example")
                            .font(.headline)
                            .foregroundStyle(colors.buttonContent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colors.buttonGradient)
                            .clipShape(RoundedRectangle(cornerRadius: smallMedium))
                    }
                }
                .padding()
                .background(colors.background2)
                .clipShape(RoundedRectangle(cornerRadius: smallMedium))
                .overlay(
                    RoundedRectangle(cornerRadius: smallMedium)
                        .stroke(colors.border1, lineWidth: 1)
                )
            }
            .padding()
        }
        .background(colors.background1)
    }
    
    @ViewBuilder
    private func colorSection(title: String, items: [(String, Color)]) -> some View {
        VStack(alignment: .leading, spacing: small) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(colors.content2)
            
            ForEach(items, id: \.0) { name, color in
                HStack {
                    RoundedRectangle(cornerRadius: small)
                        .fill(color)
                        .frame(width: extraBig, height: extraBig)
                        .overlay(
                            RoundedRectangle(cornerRadius: small)
                                .stroke(colors.border1, lineWidth: 1)
                        )
                    
                    Text(name)
                        .font(.caption)
                        .foregroundStyle(colors.content1)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(colors.background2)
        .clipShape(RoundedRectangle(cornerRadius: smallMedium))
        .overlay(
            RoundedRectangle(cornerRadius: smallMedium)
                .stroke(colors.border1, lineWidth: 1)
        )
    }
}

#Preview("Light Mode") {
    ColorsPreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ColorsPreview()
        .preferredColorScheme(.dark)
}
