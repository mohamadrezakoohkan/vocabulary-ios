//
//  ScaffoldLoadingModifier.swift
//  ICoreUI
//

import SwiftUI

struct ScaffoldLoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content.disabled(isLoading)
            if isLoading {
                LoadingOverlayView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

private struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.background.opacity(0.8).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
                .tint(.primaryRed)
        }
    }
}

public extension View {
    func scaffoldLoading(_ isLoading: Bool) -> some View {
        modifier(ScaffoldLoadingModifier(isLoading: isLoading))
    }
}

private struct LoadingPreview: View {
    @State private var isLoading = true
    var body: some View {
        VStack {
            Text("Content underneath")
                .scaffoldBackground()
                .scaffoldLoading(isLoading)
            Button("Toggle") { isLoading.toggle() }
                .buttonStyle(.appGhost)
        }
    }
}

#Preview {
    LoadingPreview()
}
