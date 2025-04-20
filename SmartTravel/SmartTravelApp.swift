//
//  SmartTravelApp.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//

import SwiftUI

@main
struct SmartTravelApp: App {
  @AppStorage("hasOnboarded") private var hasOnboarded = false
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      if hasOnboarded {
        ContentView()
          .environment(\.managedObjectContext,
                        persistenceController.container.viewContext)
      } else {
        OnboardingView {
          hasOnboarded = true
        }
      }
    }
  }
}
