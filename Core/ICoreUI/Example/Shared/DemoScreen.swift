//
//  DemoScreen.swift
//  ICoreUIExample
//
//  Two-tab scaffold used by every component demo:
//    • Interactive  — controls + live preview + generated code.
//    • Combinations — exhaustive matrix of variants.
//

import SwiftUI
import ICoreUI

enum DemoTab: String, CaseIterable, Identifiable {
    case interactive = "Interactive"
    case combinations = "Combinations"
    var id: String { rawValue }
}

struct DemoScreen<Interactive: View, Combinations: View>: View {
    let title: String
    @ViewBuilder var interactive: () -> Interactive
    @ViewBuilder var combinations: () -> Combinations

    @State private var tab: DemoTab = .interactive

    var body: some View {
        VStack(spacing: 0) {
            Picker("Mode", selection: $tab) {
                ForEach(DemoTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, medium)
            .padding(.vertical, small)

            Divider()

            Group {
                switch tab {
                case .interactive: interactive()
                case .combinations: combinations()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
