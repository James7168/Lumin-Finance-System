//
//  LuminApp.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import SwiftUI
import SwiftData

@main
struct LuminApp: App {
    @State private var settings = UserSettings()
    private let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                Account.self,
                AccountTransaction.self
            ])

            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(settings)
        }
        .modelContainer(container)
    }
}
