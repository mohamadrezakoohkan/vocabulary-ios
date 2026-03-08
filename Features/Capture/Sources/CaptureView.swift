//
//  CaptureView.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI
import DrovaCoreUI

public struct CaptureView: ScaffoldView {

    // MARK: - Color Scheme

    @Environment(\.colorScheme) var colorScheme

    // MARK: - State

    @State private var seedText: String = ""

    public init() { }

    // MARK: - Body

    public var content: some View {
        VStack(spacing: mediumBig) {
            HeaderView(
                "Plant a Seed",
                chipLabel: "🔥 12 days",
                chipStyle: .accent
            )
            ScrollView {
                VStack(spacing: mediumBig) {
                    InputView(
                        text: $seedText,
                        placeholder: "Write down your ideas...",
                        maxLength: 500
                    )
                    Button {
                        plantSeed()
                    } label: {
                        Text("Plant This Seed")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.appPrimary)

                    Text("RECENT SEEDS")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                        .fontDesign(.monospaced)
                        .foregroundStyle(colorScheme.theme.content2)
                    QuoteView(
                        text: "Friction isn't always bad UX. Sometimes it's a filter for intent.",
                        timestamp: "2h ago",
                        branchCount: 3,
                        isActive: false,
                        onTap: { },
                        onBranchesTap: { }
                    )
                    QuoteView(
                        text: "The best products feel like they were always there. Invisible design.",
                        timestamp: "yesterday",
                        branchCount: 1,
                        isActive: false,
                        onTap: { },
                        onBranchesTap: { }
                    )
                }

            }
        }
        .padding(.horizontal, medium)
    }

    // MARK: - Actions

    private func plantSeed() {
        // Handle planting seed
        print("Planting seed...")
    }
}

// MARK: - Preview

#Preview {
    CaptureView()
}
