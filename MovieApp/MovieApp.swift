//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Rana Ayman on 04/10/2023.
//

import SwiftUI

@main
struct MovieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
