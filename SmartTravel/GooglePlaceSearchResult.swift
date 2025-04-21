//
//  GooglePlaceSearchResult.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//

import Foundation
import CoreLocation

struct GooglePlaceSearchResult: Decodable {
  struct Candidate: Decodable {
    let name: String
    let formatted_address: String
    let rating: Double?
    let geometry: Geometry
  }
  struct Geometry: Decodable {
    let location: Location
  }
  struct Location: Decodable {
    let lat: Double
    let lng: Double
  }
  let candidates: [Candidate]
}

@MainActor
class PlaceDetailViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var address: String = ""
  @Published var rating: Double?
  @Published var coordinate: CLLocationCoordinate2D?

  private let apiKey = ""

  func lookup(_ query: String) async {
    // URL‑encode the query
    guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string:
            "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(q)&inputtype=textquery&fields=name,formatted_address,rating,geometry&key=\(apiKey)"
          )
    else { return }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let result = try JSONDecoder().decode(GooglePlaceSearchResult.self, from: data)
      if let first = result.candidates.first {
        name = first.name
        address = first.formatted_address
        rating  = first.rating
        coordinate = .init(
          latitude: first.geometry.location.lat,
          longitude: first.geometry.location.lng
        )
      }
    } catch {
      print("🍊 Place lookup failed:", error)
    }
  }
}
