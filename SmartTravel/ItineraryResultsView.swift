//
//  ItineraryResultsView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.

import SwiftUI
import CoreData
import UIKit  // for popToRoot()

struct ItineraryResultsView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    let trip: Trip?
    let initialDestination: String?
    @ObservedObject var viewModel: TripViewModel

    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDay = 0

    var body: some View {
        VStack(spacing: 0) {
            daySelector
            Divider()
            timeline
        }
        .onAppear(perform: loadIfExisting)
        .navigationBarBackButtonHidden(trip != nil)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if trip == nil {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: popToRoot)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: didSave)
                }
            } else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { popToRoot() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }

    // ── Day picker ────────────────────────────────────
    private var daySelector: some View {
        let plans = viewModel.generatedPlans
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(Array(plans.enumerated()), id: \.offset) { idx, plan in
                    VStack(spacing: 4) {
                        Text("Day \(String(format: "%02d", idx+1))")
                            .font(.subheadline.bold())
                        Text(plan.date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Rectangle()
                            .fill(idx == selectedDay ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                    .onTapGesture { selectedDay = idx }
                }
                if trip == nil {
                    Button { } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    // ── Timeline ─────────────────────────────────────
    private var timeline: some View {
        let plans = viewModel.generatedPlans
        guard !plans.isEmpty, selectedDay < plans.count else {
            return AnyView(Color.clear)
        }
        let events = plans[selectedDay].events

        return AnyView(
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(Array(events.enumerated()), id: \.offset) { idx, event in
                        NavigationLink {
                            ActivityDetailView(event: event)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                timelineIndicator(idx: idx, total: events.count)
                                ActivityCard(event: event)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        )
    }

    // small circle + line indicator
    private func timelineIndicator(idx: Int, total: Int) -> some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .background(Circle().fill(Color.white))
                    .frame(width: 24, height: 24)
                Text("\(idx+1)")
                    .font(.caption2.bold())
                    .foregroundColor(.blue)
            }
            if idx < total - 1 {
                Rectangle()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
        }
        .padding(.top, 4)
    }

    // MARK: – Helpers
    private var navigationTitle: String {
        if let trip = trip {
            return trip.destination ?? ""
        } else {
            return initialDestination ?? "My Trip"
        }
    }

    private func loadIfExisting() {
        guard
            let trip = trip,
            let data = trip.details,
            let plans = try? JSONDecoder().decode([DayPlan].self, from: data)
        else { return }

        viewModel.generatedPlans = plans
        selectedDay = 0
    }

    private func didSave() {
        let newTrip = Trip(context: viewContext)
        // Associate the trip with the current user
        newTrip.userId = authVM.currentUser?.id?.uuidString
        newTrip.destination = initialDestination
        if let firstDate = viewModel.generatedPlans.first?.date,
           let d1 = isoFormatter.date(from: firstDate) {
            newTrip.startDate = d1
        }
        if let lastDate = viewModel.generatedPlans.last?.date,
           let d2 = isoFormatter.date(from: lastDate) {
            newTrip.endDate = d2
        }
        if let data = try? JSONEncoder().encode(viewModel.generatedPlans) {
            newTrip.details = data
        }
        try? viewContext.save()
        popToRoot()
    }

    private func popToRoot() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootVC = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController
        else { return }

        if let nav = rootVC as? UINavigationController {
            nav.popToRootViewController(animated: true)
        } else if let nav = rootVC.findNavigationController() {
            nav.popToRootViewController(animated: true)
        }
    }

    private var isoFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }
}

// UINavigationController finder
private extension UIViewController {
    func findNavigationController() -> UINavigationController? {
        if let nav = self as? UINavigationController { return nav }
        for child in children {
            if let found = child.findNavigationController() {
                return found
            }
        }
        return nil
    }
}

