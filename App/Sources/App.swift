import SwiftUI
import SwiftData

import DrovaCoreUI

import Capture
import Revisit
import Lineage
import Evolve

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}


@main
struct DrovaApp: App {
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

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}



private struct MainView: View {

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            Tab("Capture", systemImage: Icons.sparkle.id) {
                NavigationStack {
                    CaptureView()
                }
            }

            Tab("Revisit", systemImage: Icons.arrowClockwise.id) {
                NavigationStack {
                    RevisitView()
                }
            }

            Tab("Lineage", systemImage: Icons.arrowBranch.id) {
                NavigationStack {
                    LineageView()
                }
            }

            Tab("Evolve", systemImage: Icons.buttonProgrammable.id) {
                NavigationStack {
                    EvolveView()
                }
            }
        }
        .tint(colorScheme.theme.accentPrimary)
        .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
    }
}
