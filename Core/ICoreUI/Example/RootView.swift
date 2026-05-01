//
//  RootView.swift
//  ICoreUIExample
//
//  Top-level catalog that lists every demo screen.
//

import SwiftUI
import ICoreUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Foundations") {
                    NavigationLink("Colors") { ColorsDemo() }
                    NavigationLink("Icons")  { IconsDemo() }
                }

                Section("Views") {
                    NavigationLink("BadgeView")     { BadgeViewDemo() }
                    NavigationLink("ChipView")      { ChipViewDemo() }
                    NavigationLink("FlashcardView") { FlashcardViewDemo() }
                    NavigationLink("HeaderView")    { HeaderViewDemo() }
                    NavigationLink("InputView")       { InputViewDemo() }
                    NavigationLink("ProgressBarView") { ProgressBarViewDemo() }
                    NavigationLink("QuoteView")     { QuoteViewDemo() }
                    NavigationLink("ReviewView")    { ReviewViewDemo() }
                }

                Section("Styles") {
                    NavigationLink("BadgeStyle")  { BadgeStyleDemo() }
                    NavigationLink("ButtonStyle") { ButtonStyleDemo() }
                    NavigationLink("CardStyle")   { CardStyleDemo() }
                    NavigationLink("ChipStyle")   { ChipStyleDemo() }
                    NavigationLink("CornerStyle") { CornerStyleDemo() }
                }
            }
            .navigationTitle("ICoreUI")
        }
    }
}

#Preview {
    RootView()
}
