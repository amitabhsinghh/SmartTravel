//
//  ItineraryResultsView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//
import SwiftUI
import CoreData

struct ItineraryResultsView: View {
    /// non‑nil for a saved trip, `nil` when building a brand‑new trip
    let trip: Trip?
    let initialDestination: String?
    @ObservedObject var viewModel: TripViewModel

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode)  private var presentationMode

    @State private var selectedDay = 0

    var body: some View {
        VStack(spacing: 0) {
            daySelector
            Divider()
            timeline
        }
        .onAppear(perform: loadIfExisting)
        // hide the system back‑arrow when we're looking at a saved trip
        .navigationBarBackButtonHidden(trip != nil)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // ── New‑trip flow: Cancel + Save ─────────────────
            if trip == nil {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: cancelAll)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save",   action: saveAndExit)
                }
            }
            // ── Saved‑trip flow: single custom Back ─────────
            else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }

    // MARK: – Subviews

    private var daySelector: some View {
        let plans = viewModel.generatedPlans
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(Array(plans.enumerated()), id: \.offset) { idx, plan in
                    VStack(spacing: 4) {
                        Text("Day \(String(format: "%02d", idx+1))")
                            .font(.subheadline.bold())
                        Text(plan.date)
                            .font(.caption).foregroundColor(.secondary)
                        Rectangle()
                            .fill(idx == selectedDay ? Color.blue : Color.clear)
                            .frame(height: 2)
                    }
                    .onTapGesture { selectedDay = idx }
                }
                if trip == nil {
                    Button { /* optional: add another day */ } label: {
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
                        HStack(alignment: .top, spacing: 12) {
                            timelineIndicator(idx: idx, total: events.count)
                            ActivityCard(event: event)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        )
    }

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
          viewModel.generatedPlans.isEmpty,
          let data = trip.details,
          let plans = try? JSONDecoder().decode([DayPlan].self, from: data)
        else { return }
        viewModel.generatedPlans = plans
    }

    private func saveAndExit() {
        let newTrip = Trip(context: viewContext)
        newTrip.destination = initialDestination
        if let ds = viewModel.generatedPlans.first?.date,
           let d1 = isoFormatter.date(from: ds) {
            newTrip.startDate = d1
        }
        if let de = viewModel.generatedPlans.last?.date,
           let d2 = isoFormatter.date(from: de) {
            newTrip.endDate = d2
        }
        if let data = try? JSONEncoder().encode(viewModel.generatedPlans) {
            newTrip.details = data
        }
        try? viewContext.save()
        cancelAll()
    }

    private func cancelAll() {
        viewModel.generatedPlans = []
        viewModel.showResult      = false

        // dismiss itinerary view
        presentationMode.wrappedValue.dismiss()
        // then dismiss review screen
        DispatchQueue.main.async {
            presentationMode.wrappedValue.dismiss()
        }
    }

    private var isoFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }
}

