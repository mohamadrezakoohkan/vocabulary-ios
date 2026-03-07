//
//  InputView.swift
//  DrovaCoreUI
//
//  Created by Mohammad reza on 7/3/26.
//

import SwiftUI

/// A reusable input component with a vertical scrolling text field
/// Supports placeholder text, customizable height, and text binding
public struct InputView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }

    // MARK: - Properties
    
    /// The text binding for the input field
    @Binding private var text: String
    
    /// Placeholder text to display when the input is empty
    private let placeholder: String
    
    /// Minimum height for the text editor
    private let minHeight: CGFloat

    /// Maximum height for the text editor
    private let maxHeight: CGFloat

    /// Whether the input is focused
    @FocusState private var isFocused: Bool
    
    // MARK: - Initialization
    
    /// Creates an input field with text binding
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - placeholder: Placeholder text to display when empty (default: "Enter text...")
    ///   - minHeight: Minimum height for the text editor (default: 120)
    ///   - maxHeight: Maximum height for the text editor (default: 500)
    public init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        minHeight: CGFloat = 120,
        maxHeight: CGFloat = 500
    ) {
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder text
            if text.isEmpty {
                Text(placeholder)
                    .font(.body)
                    .foregroundStyle(colors.content2)
                    .padding(small)
            }

            // Text editor with vertical scrolling
            TextEditor(text: $text)
                .font(.body)
                .foregroundStyle(colors.content1)
                .scrollContentBackground(.hidden)
                .lineSpacing(4)
                .background(Color.clear)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .focused($isFocused)
        }
        .cardStyle(
            paddingHorizontal: medium,
            paddingVertical: smallMedium,
            backgroundColor: colors.background2,
            borderColor: isFocused ? colors.accentBorder : colors.border1,
            cornerStyle: .rounded(smallMedium)
        )
    }
}

// MARK: - Preview

private struct InputPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                
                // Interactive demo
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Interactive Example")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    InteractiveInputDemo()
                }
                
                // Standard input
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Standard Input")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    InputView(text: .constant(""))
                }
                
                // Input with text
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("With Text")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    InputView(
                        text: .constant("This is some example text that demonstrates the input component with content. The text editor supports vertical scrolling when content exceeds the minimum height.")
                    )
                }
                
                // Custom placeholder
                VStack(alignment: .leading, spacing: smallMedium) {
                    Text("Custom Placeholder")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colors.content2)
                    
                    InputView(
                        text: .constant(""),
                        placeholder: "Write your seed here..."
                    )
                }
            }
            .padding()
        }
        .background(colors.background1)
    }
}

// MARK: - Interactive Demo

/// Demo component showing interactive input behavior
private struct InteractiveInputDemo: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var inputText: String = ""
    
    private var colors: any ColorTheme {
        colorScheme.theme
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: smallMedium) {
            InputView(
                text: $inputText,
                placeholder: "Type something to see the character count...",
                minHeight: 100
            )
            
            // Character count display
            HStack {
                Text("Characters: \(inputText.count)")
                    .font(.caption)
                    .foregroundStyle(colors.content2)
                
                Spacer()
                
                if !inputText.isEmpty {
                    Button(action: {
                        inputText = ""
                    }) {
                        Text("Clear")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(colors.alertDangerContent)
                    }
                }
            }
        }
    }
}
#Preview("Light Mode") {
    InputPreview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    InputPreview()
        .preferredColorScheme(.dark)
}

