//
//  DataController.swift
//  MoodTracker
//
//  Created by Марк Горкій on 16.07.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "MoodModel")
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    func save(context:NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!!!")
        } catch {
            print("Data is NOT saved :(")
        }
    }
    func AddMood(name: String, points:Double, context:NSManagedObjectContext) {
        let mood = Mood(context: context)
        mood.id = UUID()
        mood.date = Date()
        mood.name = name
        mood.points = points
        
        save(context:context)
    }
    func editMood(mood: Mood, points: Double, name: String, context: NSManagedObjectContext) {
        mood.name = name
        mood.points = points
        
        save(context: context)
    }
}
