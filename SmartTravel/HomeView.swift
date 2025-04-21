//
//  HomeView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext

    // MARK: – Wizard state
    @State private var showSearch    = false
    @State private var showTravelers = false
    @State private var showBudget    = false
    @State private var showDates     = false

    // MARK: – Collected data
    @State private var chosenDestination = ""
    @State private var chosenParty: TravelParty?
    @State private var chosenBudget: BudgetChoice?

    var body: some View {
        TabView {
            // ───────────────────────────────────────────
            // My Trips Tab
            // ───────────────────────────────────────────
            NavigationView {
                ZStack {
                    MyTripsView(onAdd: { showSearch = true })
                        .environment(\.managedObjectContext, viewContext)
                        .environmentObject(authVM)

                    // Step 1 → Destination Search
                    NavigationLink(
                        destination:
                            DestinationSearchView { dest in
                                chosenDestination = dest
                                showTravelers = true
                            }
                            .environment(\.managedObjectContext, viewContext),
                        isActive: $showSearch
                    ) { EmptyView() }
                    .hidden()

                    // Step 2 → Select Travelers
                    NavigationLink(
                        destination:
                            SelectTravelersView { party in
                                chosenParty = party
                                showBudget = true
                            },
                        isActive: $showTravelers
                    ) { EmptyView() }
                    .hidden()

                    // Step 3 → Select Budget
                    NavigationLink(
                        destination:
                            BudgetSelectionView { choice in
                                chosenBudget = choice
                                showDates = true
                            },
                        isActive: $showBudget
                    ) { EmptyView() }
                    .hidden()

                    // Step 4 → Select Dates
                    NavigationLink(
                        isActive: $showDates,
                        destination: {
                            if let party = chosenParty, let budget = chosenBudget {
                                TravelDateView(
                                    destination: chosenDestination,
                                    party:       party,
                                    budget:      budget
                                )
                                .environment(\.managedObjectContext, viewContext)
                                .environmentObject(authVM)
                            } else {
                                Text("Missing selection")
                                    .foregroundColor(.red)
                            }
                        },
                        label: { EmptyView() }
                    )
                    .hidden()
                }
                // We *do not* call .navigationBarHidden(true) here,
                // so child pushes (including saved itineraries) get back arrows automatically.
            }
            .tabItem {
                Label("My Trips", systemImage: "suitcase.fill")
            }

            // ───────────────────────────────────────────
            // Discover Tab
            // ───────────────────────────────────────────
            NavigationView {
                Text("Discover")
            }
            .tabItem {
                Label("Discover", systemImage: "globe")
            }

            // ───────────────────────────────────────────
            // Profile Tab
            // ───────────────────────────────────────────
            NavigationView {
                ProfileView(vm: authVM)
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

