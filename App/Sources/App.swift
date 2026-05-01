import SwiftUI
import SwiftData

import ICoreUI
import SharedCommon

import Splash
import Deck
import Stats
import Study


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
    var body: some View {
        TabView {
            DeckView()
                .tabItem {
                    Icon(.deckTab)
                }

            StudyView()
                .tabItem {
                    Icon(.studyTab)
                }

            StatsView()
                .tabItem {
                    Icon(.statsTab)
                }
        }
        .symbolRenderingMode(.palette)
        .foregroundStyle(Color.primaryYellow, Color.primaryRed)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.primaryRed)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryRed)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
