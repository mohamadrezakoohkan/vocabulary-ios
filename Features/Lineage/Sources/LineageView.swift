//
//  LineageView.swift
//  Drova
//
//  Created by Mohammad reza on 8/3/26.
//

import SwiftUI
import DrovaCoreUI

public struct LineageView: View {

    // MARK: - Color Scheme

    @Environment(\.colorScheme) var colorScheme

    // MARK: - State

    @State private var seedText: String = ""

    public init() { }

    // MARK: - Body

    public var body: some View {
        colorScheme.theme.background1
    }

    // MARK: - Actions

    private func plantSeed() {
        // Handle planting seed
        print("Planting seed...")
    }
}

// MARK: - Preview

#Preview {
    LineageView()
}
