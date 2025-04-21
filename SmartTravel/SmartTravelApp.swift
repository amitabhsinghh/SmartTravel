//
//  SmartTravelApp.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.

import SwiftUI

@main
struct SmartTravelApp: App {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @StateObject private var authVM = AuthViewModel(
        context: PersistenceController.shared.container.viewContext
    )
    @StateObject private var tripVM = TripViewModel()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if !hasOnboarded {
                OnboardingView(onComplete: { hasOnboarded = true })

            } else if !authVM.isLoggedIn {
                LoginView(vm: authVM)
                  .environment(\.managedObjectContext,
                               persistenceController.container.viewContext)

            } else {
                HomeView()
                  .environment(\.managedObjectContext,
                               persistenceController.container.viewContext)
                  .environmentObject(authVM)
                  .environmentObject(tripVM)
            }
        }
    }
}
