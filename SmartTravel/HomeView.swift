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

    // MARK: – Flow flags
    @State private var showSearch    = false
    @State private var showTravelers = false
    @State private var showBudget    = false
    @State private var showDates     = false

    // MARK: – Collected data
    @State private var chosenDestination = ""
    @State private var chosenParty: TravelParty?
    @State private var chosenBudget: BudgetChoice?

    var body: some View {
        NavigationView {
            ZStack {
                // Main tabs
                TabView {
                    MyTripsView(onAdd: { showSearch = true })
                        .tabItem { Label("My Trip", systemImage: "suitcase.fill") }

                    Text("Discover")
                        .tabItem { Label("Discover", systemImage: "globe") }

                    ProfileView(vm: authVM)
                        .tabItem { Label("Profile", systemImage: "person.circle") }
                }

                // Step 1 → Destination Search
                NavigationLink(
                    destination:
                        DestinationSearchView { dest in
                            chosenDestination = dest
                            showTravelers = true
                        }
                        .environment(\.managedObjectContext, viewContext),
                    isActive: $showSearch
                ) {
                    EmptyView()
                }
                .hidden()

                // Step 2 → Select Travelers
                NavigationLink(
                    destination:
                        SelectTravelersView { party in
                            chosenParty = party
                            showBudget = true
                        },
                    isActive: $showTravelers
                ) {
                    EmptyView()
                }
                .hidden()

                // Step 3 → Select Budget
                NavigationLink(
                    destination:
                        BudgetSelectionView { choice in
                            chosenBudget = choice
                            showDates = true
                        },
                    isActive: $showBudget
                ) {
                    EmptyView()
                }
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
                        } else {
                            Text("Missing selection")
                                .foregroundColor(.red)
                        }
                    },
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            }
            .navigationBarHidden(true)
        }
    }
}


