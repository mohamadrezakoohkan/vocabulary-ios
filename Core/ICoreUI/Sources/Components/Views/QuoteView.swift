//
//  QuoteView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

/// A mention/quote component that displays a text snippet with metadata
/// Shows the quote text, timestamp, and branch count wrapped in a card style
public struct QuoteView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    // MARK: - Properties
    
    /// The quote/mention text to display
    private let text: String
    
    /// The timestamp text (e.g., "2h ago", "yesterday")
    private let timestamp: String
    
    /// The number of branches
    private let branchCount: Int
    
    /// Whether the mention is in an active state
    private let isActive: Bool
    
    /// Optional action when the mention is tapped
    private let onTap: (() -> Void)?
    
    /// Optional action when the branches section is tapped
    private let onBranchesTap: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a mention component
    /// - Parameters:
    ///   - text: The quote/mention text to display
    ///   - timestamp: The timestamp text (default: "")
    ///   - branchCount: The number of branches (default: 0)
    ///   - isActive: Whether the mention is in an active state (default: true)
    ///   - onTap: Optional action when the mention is tapped
    ///   - onBranchesTap: Optional action when the branches section is tapped
    public init(
        text: String,
        timestamp: String = "",
        branchCount: Int = 0,
        isActive: Bool = true,
        onTap: (() -> Void)? = nil,
        onBranchesTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.timestamp = timestamp
        self.branchCount = branchCount
        self.isActive = isActive
        self.onTap = onTap
        self.onBranchesTap = onBranchesTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: medium) {
                // Main quote text
                Text(text)
                    .font(.body)
                    .foregroundStyle(isActive ? colors.content1 : colors.content2)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Bottom metadata row
                HStack(alignment: .center) {
                    // Timestamp on the left
                    if !timestamp.isEmpty {
                        Text(timestamp)
                            .font(.caption.monospaced())
                            .foregroundStyle(colors.content3)
                    }
                    
                    Spacer()
                    
                    // Branch count on the right
                    if branchCount > 0 {
                        Button(action: {
                            onBranchesTap?()
                        }) {
                            HStack(spacing: extraSmall) {
                                Icon(.branch, size: .small, color: colors.accentSecondary)

                                Text("\(branchCount) \(branchCount == 1 ? "branch" : "branches")")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(colors.accentSecondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .cardStyle(
                paddingHorizontal: medium,
                paddingVertical: medium,
                backgroundColor: colors.background2,
                borderColor: colors.border1,
                cornerStyle: .rounded(smallMedium)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

private struct QuotePreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                
                // Example from the screenshot
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Screenshot Example")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                        timestamp: "2h ago",
                        branchCount: 3
                    )
                }

                // Inactive state
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Inactive")
                        .font(.caption)
                        .foregroundStyle(colors.content2)

                    QuoteView(
                        text: "The best time to plant a tree was 20 years ago. The second best time is now.",
                        timestamp: "5m ago",
                        branchCount: 16,
                        isActive: false
                    )
                }

                // Single branch
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Single Branch")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "The best time to plant a tree was 20 years ago. The second best time is now.",
                        timestamp: "5m ago",
                        branchCount: 1
                    )
                }
                
                // Multiple branches
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Multiple Branches")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "Design is not just what it looks like and feels like. Design is how it works.",
                        timestamp: "yesterday",
                        branchCount: 7
                    )
                }
                
                // No branch count
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("No Branches")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "Simplicity is the ultimate sophistication.",
                        timestamp: "3d ago",
                        branchCount: 0
                    )
                }
                
                // No timestamp
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("No Timestamp")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "Make it work, make it right, make it fast.",
                        branchCount: 5
                    )
                }
                
                // Long text example
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Long Text")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    QuoteView(
                        text: "The most profound technologies are those that disappear. They weave themselves into the fabric of everyday life until they are indistinguishable from it.",
                        timestamp: "1w ago",
                        branchCount: 12
                    )
                }
                
                // Interactive example
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive (Tap Card & Branches)")
                        .font(.caption)
                        .foregroundStyle(colors.content2)
                    
                    InteractiveMentionDemo()
                }
            }
            .padding()
        }
        .background(colors.background1)
    }
}

// MARK: - Interactive Demo

/// Demo component showing interactive mention behavior
private struct InteractiveMentionDemo: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var cardTapCount: Int = 0
    @State private var branchTapCount: Int = 0
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: smallMedium) {
            QuoteView(
                text: "Every good design begins with an even better story.",
                timestamp: "just now",
                branchCount: 3,
                onTap: {
                    cardTapCount += 1
                },
                onBranchesTap: {
                    branchTapCount += 1
                }
            )
            
            if cardTapCount > 0 || branchTapCount > 0 {
                VStack(alignment: .leading, spacing: extraSmall) {
                    if cardTapCount > 0 {
                        Text("Card tapped \(cardTapCount) time\(cardTapCount == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(colors.content2)
                    }
                    
                    if branchTapCount > 0 {
                        Text("Branches tapped \(branchTapCount) time\(branchTapCount == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(colors.accentSecondary)
                    }
                }
            }
        }
    }
}
#Preview("Light Mode") {
    QuotePreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    QuotePreview()
        .preferredColorScheme(.dark)
}

