//
//  GeoSmoke_revampApp.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 08/05/25.
//

import SwiftUI
import SwiftData

@main
struct GeoSmoke_revampApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            SmokingArea.self
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
            RootView()
                .preferredColorScheme(.light)
//            MapView()
//                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
