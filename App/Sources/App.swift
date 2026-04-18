import SwiftUI
import SwiftData

import ICoreUI
import SharedCommon

import Splash


@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}


@main
struct MainApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let serviceProvider = ServiceProvider()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.serviceProvider, serviceProvider)
        }
        .modelContainer(sharedModelContainer)
    }
}



private struct MainView: View {

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            SplashView()
        }
        .tint(colorScheme.theme.accentPrimary)
        .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
    }
}
