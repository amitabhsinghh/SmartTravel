//
//  ActivityDetailView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.

import SwiftUI
import MapKit

struct ActivityDetailView: View {
  let event: Event
  @StateObject private var vm = PlaceDetailViewModel()
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
  )

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        // 1) Event title
        Text(event.name)
          .font(.largeTitle).bold()
          .padding(.top)

        // 2) Fetched place details
        if vm.name.isEmpty {
          ProgressView("Loading place info…")
        } else {
          Text(vm.name)
            .font(.title2)
          Text(vm.address)
            .font(.subheadline)
            .foregroundColor(.secondary)

          if let r = vm.rating {
            HStack(spacing: 4) {
              Image(systemName: "star.fill")
                .foregroundColor(.yellow)
              Text(String(format: "%.1f", r))
            }
          }
        }

        // 3) Map
        if let coord = vm.coordinate {
          Map(coordinateRegion: $region, annotationItems: [coord]) { loc in
            MapMarker(coordinate: loc, tint: .red)
          }
          .frame(height: 300)
          .cornerRadius(12)
          .onAppear {
            region.center = coord
          }
        }
      }
      .padding(.horizontal)
    }
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      // Kick off the lookup when this view appears
      await vm.lookup(event.location)
    }
  }
}

// Conform CLLocationCoordinate2D to Identifiable for MapMarker
extension CLLocationCoordinate2D: Identifiable {
  public var id: String {
    "\(latitude),\(longitude)"
  }
}
