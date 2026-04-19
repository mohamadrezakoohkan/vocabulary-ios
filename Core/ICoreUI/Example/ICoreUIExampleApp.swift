//
//  ICoreUIExampleApp.swift
//  ICoreUIExample
//
//  Demo app showcasing every component in
//  Core/ICoreUI/Sources/Components/Views and
//  Core/ICoreUI/Sources/Components/Styles.
//
//  Each component has its own dedicated demo screen with two tabs:
//    1. Interactive — every constructor input is wired to a control,
//       the live component is rendered, and the matching Swift code
//       snippet is generated.
//    2. Combinations — every reasonable combination of the component
//       UI is rendered side-by-side.
//

import SwiftUI
import ICoreUI

@main
struct ICoreUIExampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    print("ICoreUIExample Running...")
                }
        }
    }
}
