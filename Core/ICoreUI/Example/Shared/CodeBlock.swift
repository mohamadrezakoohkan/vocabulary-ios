//
//  CodeBlock.swift
//  ICoreUIExample
//
//  Monospaced code preview with a one-tap copy button.
//

import SwiftUI
import UIKit
import ICoreUI

struct CodeBlock: View {
    let code: String

    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            HStack {
                Text("Swift")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    UIPasteboard.general.string = code
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        didCopy = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { didCopy = false }
                    }
                } label: {
                    Label(didCopy ? "Copied" : "Copy",
                          systemImage: didCopy ? "checkmark" : "doc.on.doc")
                        .font(.caption.weight(.semibold))
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderless)
                .tint(didCopy ? .primaryGreen : .primaryBlue)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.foreground)
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
                    .padding(.vertical, extraSmall)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(
            paddingHorizontal: medium,
            paddingVertical: smallMedium,
            backgroundColor: .surface,
            borderColor: Color.foregroundMuted.opacity(0.2),
            cornerStyle: .medium
        )
    }
}

// MARK: - Code Builder Helpers

/// Encodes a Swift `String` literal with proper escaping.
func swiftStringLiteral(_ value: String) -> String {
    let escaped = value
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
        .replacingOccurrences(of: "\n", with: "\\n")
    return "\"\(escaped)\""
}

/// Builds a Swift initializer call with optional arguments. Lines are
/// indented with 4 spaces for readability.
func swiftCall(
    _ name: String,
    positional: [String] = [],
    arguments: [(label: String, value: String?)] = []
) -> String {
    let parts: [String] = positional + arguments.compactMap { arg in
        guard let value = arg.value else { return nil }
        return "\(arg.label): \(value)"
    }

    if parts.isEmpty {
        return "\(name)()"
    }

    if parts.count == 1, !parts[0].contains("\n"), parts[0].count < 40 {
        return "\(name)(\(parts[0]))"
    }

    let body = parts.map { "    \($0)" }.joined(separator: ",\n")
    return "\(name)(\n\(body)\n)"
}
