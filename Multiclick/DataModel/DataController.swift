//
//  DataController.swift
//  Multiclick
//
//  Created by Dev-LU on 01.09.22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    //Set up Core Data stack
    let container = NSPersistentContainer(name: "Model")
    
    // Load data when container is created
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Data \(error.localizedDescription)")
            }
        }
    }
    
    
    // Save data
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("Data not saved")
        }
    }

    
    // Add data
    func addCounter(name: String,
                    count: Int32,
                    step: Int32,
                    goal: Int32,
                    goalActive: Bool,
                    note: String,
                    id: Int16,
                    context: NSManagedObjectContext) {
        let counter = Counter(context: context)
        counter.counterID = UUID()
        counter.counterName = name
        counter.counterCount = count
        counter.counterStep = step
        counter.counterGoal = goal
        counter.counterGoalActive = goalActive
        counter.counterNote = note
        
        save(context: context)
    }
    
    func editCounter(name: String,
                     count: Int32,
                     step: Int32,
                     goal: Int32,
                     note: String,
                     context: NSManagedObjectContext) {
        let counter = Counter(context: context)
        counter.counterName = name
        counter.counterCount = count
        counter.counterStep = step
        counter.counterGoal = goal
        counter.counterNote = note
        
        save(context: context)
    }
}
