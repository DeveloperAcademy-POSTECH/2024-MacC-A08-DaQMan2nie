//
//  SignalApp.swift
//  Signal
//
//  Created by Pil_Gaaang on 12/4/24.
//

import SwiftUI

@main
struct SignalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
