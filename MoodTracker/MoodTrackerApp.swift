//
//  MoodTrackerApp.swift
//  MoodTracker
//
//  Created by Марк Горкій on 16.07.2023.
//

import SwiftUI

@main
struct MoodTrackerApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
