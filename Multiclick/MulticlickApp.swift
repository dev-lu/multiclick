//
//  MulticlickApp.swift
//  Multiclick
//
//  Created by Dev-LU on 01.09.22.
//

import SwiftUI

@main
struct MulticlickApp: App {
    let persistenceController = PersistenceController.shared
    
    // Inject DB in app
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)  //Store data in memory
        }
    }
}
