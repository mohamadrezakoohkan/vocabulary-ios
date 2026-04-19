//
//  Controls.swift
//  ICoreUIExample
//
//  Reusable form-style controls used inside the Interactive demo tabs.
//

import SwiftUI
import ICoreUI

// MARK: - Section

struct ControlsSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: small) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.foregroundMuted)

            VStack(alignment: .leading, spacing: small) {
                content()
            }
            .padding(medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.foregroundMuted.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

// MARK: - Labeled Row

struct LabeledRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack(alignment: .center, spacing: small) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.foreground)
            Spacer(minLength: small)
            content()
        }
    }
}

// MARK: - Text Field Row

struct TextFieldRow: View {
    let label: String
    @Binding var text: String
    var prompt: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: extraSmall) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.foreground)
            TextField(prompt, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .font(.body)
        }
    }
}

// MARK: - Stepper Row

struct StepperRow: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        LabeledRow(label: label) {
            Stepper(value: $value, in: range) {
                Text("\(value)")
                    .font(.body.monospacedDigit())
            }
        }
    }
}

// MARK: - Slider Row

struct SliderRow: View {
    let label: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    var step: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: extraSmall) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(value)) pt")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}
