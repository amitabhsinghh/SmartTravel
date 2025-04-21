//
//  MyTripsView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI
import CoreData

struct MyTripsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var tripVM: TripViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default
    )
    private var trips: FetchedResults<Trip>

    let onAdd: () -> Void

    var body: some View {
        Group {
            if trips.isEmpty {
                emptyState
            } else {
                listState
            }
        }
        .navigationTitle("My Trips")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: onAdd) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 48))
                .foregroundColor(.gray)

            Text("No Trips Yet")
                .font(.title2).bold()

            Text("Time to plan your next journey.\nThe world is waiting for you to explore!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button("Start New Trip", action: onAdd)
                .padding(.vertical, 14)
                .frame(maxWidth: 200)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var listState: some View {
        List {
            ForEach(trips) { trip in
                NavigationLink {
                    ItineraryResultsView(
                        trip: trip,
                        initialDestination: nil,
                        viewModel: tripVM
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.destination ?? "Untitled")
                            .font(.headline)
                        if let start = trip.startDate, let end = trip.endDate {
                            Text("\(start, formatter: dateFormatter) – \(end, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .onDelete { offsets in
                withAnimation {
                    offsets.map { trips[$0] }.forEach(viewContext.delete)
                    try? viewContext.save()
                }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
}
