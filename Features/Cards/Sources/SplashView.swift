//
//  SplashView.swift
//  PROJECT_NAME
//
//  Created by Mohammad reza on 17/4/26.
//

import SwiftUI
import ICoreUI

public struct SplashView: ScaffoldView {

    // MARK: - Color Scheme

    @Environment(\.colorScheme) var colorScheme

    public var header: ScaffoldHeaderConfig? {
        ScaffoldHeaderConfig(
            title: Strings.Capture.title,
            accessory: HeaderAccessory.chip(
                label: Strings.Capture.streak("12"),
                mode: HeaderChipMode.display(style: .accent)
            )
        )
    }

    // MARK: - State

    @State private var seedText: String = ""

    public init() { }

    // MARK: - Body

    public var content: some View {
        VStack(spacing: mediumBig) {
            InputView(
                text: $seedText,
                placeholder: Strings.Capture.placeholder,
                maxLength: 500
            )

            Button {
                plantSeed()
            } label: {
                Text(Strings.Capture.plantButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.appPrimary)

            Text(Strings.Capture.recentSeeds)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)
                .fontDesign(.monospaced)
                .foregroundStyle(colorScheme.theme.content2)
            QuoteView(
                text: Strings.Capture.Sample.quote1,
                timestamp: Strings.Time.hoursAgo("2"),
                branchCount: 3,
                isActive: false,
                onTap: { },
                onBranchesTap: { }
            )
            QuoteView(
                text: Strings.Capture.Sample.quote2,
                timestamp: Strings.Time.yesterday,
                branchCount: 1,
                isActive: false,
                onTap: { },
                onBranchesTap: { }
            )
        }
    }

    // MARK: - Actions

    private func plantSeed() {
        // Handle planting seed
        print("Planting seed...")
    }
}

// MARK: - Preview

#Preview {
    SplashView()
}
