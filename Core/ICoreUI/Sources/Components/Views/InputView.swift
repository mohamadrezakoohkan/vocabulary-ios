//
//  InputView.swift
//  ICoreUI
//
//  Apple HIG multi-line text input — surface background, hairline border,
//  smooth focus tint, optional character counter and inline clear button.
//
//  AI Instructions:
//  - This component follows Apple Human Interface Guidelines.
//  - Background: Color.surface — never a heavy fill or hard contrast.
//  - Border: hairline (1pt) using a low-opacity foreground tint; on focus
//    it animates to the accent color. Do NOT use thick (2-3pt) borders or
//    abrupt width swaps — animate color only so the layout never shifts.
//  - Corners: continuous .medium (12pt). Do NOT use square corners.
//  - Shadow: none by default (HIG inputs sit flat on the surface).
//  - Typography: .body for input + placeholder so they align perfectly.
//  - Placeholder padding MUST match TextEditor's intrinsic textContainerInset
//    (≈5pt horizontal, ≈8pt vertical) — adjust here if iOS changes defaults.
//  - Focus animation uses .easeInOut(0.2) on isFocused only — never animate
//    on text changes (it causes typing jank).
//  - Character counter appears only when maxLength is set; turns
//    .primaryRed when within 10% of the limit.
//  - Clear button appears only while focused AND text is non-empty; keep
//    the tap target ≥ 28pt and use a soft scale press feedback.
//  - Respect Dynamic Type — never hardcode font sizes.
//  - Accessibility: forward placeholder as accessibility label when empty
//    and announce character count via accessibilityValue.
//  - Keep the public init backwards compatible (text, placeholder,
//    minHeight, maxHeight, maxLength). New options must be additive.
//  - Previews: light + dark, showing empty / typed / counter / error-ish states.
//  - Demo: Core/ICoreUI/Example/Components/Views/InputViewDemo.swift
//    Update the Interactive controls and Combinations gallery there
//    whenever a new init parameter or visual state is introduced.
//

import SwiftUI

public struct InputView: View {
    @Binding private var text: String
    private let placeholder: String
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    private let maxLength: Int?
    private let accentColor: Color
    private let showsClearButton: Bool

    @FocusState private var isFocused: Bool

    // Matches TextEditor's intrinsic textContainerInset so the placeholder
    // sits exactly on top of the first character the user will type.
    private let textInsetHorizontal: CGFloat = 5
    private let textInsetVertical: CGFloat = 8

    public init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        minHeight: CGFloat = 120,
        maxHeight: CGFloat = 500,
        maxLength: Int? = nil,
        accentColor: Color = .primaryBlue,
        showsClearButton: Bool = true
    ) {
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.maxLength = maxLength
        self.accentColor = accentColor
        self.showsClearButton = showsClearButton
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: extraSmall) {
            editor
                .cardStyle(
                    paddingHorizontal: small,
                    paddingVertical: small,
                    backgroundColor: .surface,
                    borderColor: borderColor,
                    borderWidth: 1,
                    cornerStyle: .medium,
                    shadow: nil
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            if let maxLength {
                counter(maxLength: maxLength)
                    .padding(.horizontal, extraSmall)
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Editor

    private var editor: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.body)
                    .foregroundStyle(Color.foregroundMuted)
                    .padding(.horizontal, textInsetHorizontal)
                    .padding(.vertical, textInsetVertical)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
                    .transition(.opacity)
            }

            TextEditor(text: $text)
                .font(.body)
                .foregroundStyle(.foreground)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .tint(accentColor)
                .lineSpacing(2)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .focused($isFocused)
                .onChange(of: text) { _, newValue in
                    guard let maxLength, newValue.count > maxLength else { return }
                    text = String(newValue.prefix(maxLength))
                }
                .accessibilityLabel(text.isEmpty ? placeholder : "")
                .accessibilityValue(accessibilityValue)

            if showsClearButton, isFocused, !text.isEmpty {
                clearButton
                    .padding(.top, textInsetVertical)
                    .padding(.trailing, textInsetHorizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    private var clearButton: some View {
        Button {
            text = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.body)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.foregroundMuted)
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
        }
        .buttonStyle(ClearButtonStyle())
        .accessibilityLabel("Clear text")
    }

    // MARK: - Counter

    private func counter(maxLength: Int) -> some View {
        let count = text.count
        let remaining = maxLength - count
        let isNearLimit = remaining <= max(10, maxLength / 10)

        return Text("\(count)/\(maxLength)")
            .font(.caption2.monospacedDigit())
            .foregroundStyle(isNearLimit ? Color.primaryRed : Color.foregroundMuted)
            .animation(.easeInOut(duration: 0.15), value: isNearLimit)
            .accessibilityHidden(true)
    }

    // MARK: - Helpers

    private var borderColor: Color {
        isFocused ? accentColor : Color.foregroundMuted.opacity(0.2)
    }

    private var accessibilityValue: String {
        guard let maxLength else { return text }
        return "\(text), \(text.count) of \(maxLength) characters"
    }
}

// MARK: - Button Style

private struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

// MARK: - Preview

private struct InputPreview: View {
    @State private var empty: String = ""
    @State private var typed: String = "Typed content example."
    @State private var counted: String = "Almost at the limit of this short input field."

    var body: some View {
        ScrollView {
            VStack(spacing: mediumBig) {
                InputView(text: $empty, placeholder: "Write your word here...")
                InputView(text: $typed)
                InputView(
                    text: $counted,
                    placeholder: "With character counter",
                    minHeight: 80,
                    maxLength: 60
                )
                InputView(
                    text: .constant(""),
                    placeholder: "Red accent variant",
                    accentColor: .primaryRed
                )
            }
            .padding(medium)
        }
        .background(.background)
    }
}

#Preview("Light Mode") {
    InputPreview().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    InputPreview().preferredColorScheme(.dark)
}
