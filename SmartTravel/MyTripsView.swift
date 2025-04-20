//
//  MyTripsView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//


import SwiftUI
import CoreData

struct MyTripsView: View {
  @Environment(\.managedObjectContext) private var viewContext


  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Trip.date, ascending: true)],
    animation: .default)
  private var trips: FetchedResults<Trip>

  let onAdd: () -> Void

  var body: some View {
    NavigationView {
      Group {
        if trips.isEmpty {
          // Empty state
          VStack(spacing: 16) {
            Image(systemName: "mappin.and.ellipse")
              .font(.system(size: 48))
              .foregroundColor(.gray)

            Text("No Trips Yet")
              .font(.title2)
              .fontWeight(.bold)

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
        } else {
          // List of existing trips
          List {
            ForEach(trips) { trip in
              NavigationLink(destination: Text(trip.name ?? "Untitled")) {
                VStack(alignment: .leading) {
                  Text(trip.name ?? "Untitled")
                    .font(.headline)
                  if let date = trip.date {
                    Text(date, style: .date)
                      .font(.subheadline)
                      .foregroundColor(.secondary)
                  }
                }
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
      }
      .navigationTitle("My Trips")
      .toolbar {
        if !trips.isEmpty {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: onAdd) {
              Image(systemName: "plus")
            }
          }
        }
      }
    }
  }
}
