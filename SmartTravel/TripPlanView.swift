//
//  TripPlanView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//

import SwiftUI

struct TripPlanView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Image
                Image("dummy")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 230)
                    .clipped()

                VStack(spacing: 24) {
                    // Trip Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Label("04 Aug 2024 - 07 Aug 2024", systemImage: "calendar")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Label("Travel Group: Family", systemImage: "person.3.fill")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Flights
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🛫 Recommended Flights")
                            .font(.headline)
                            .fontWeight(.bold)

                        FlightCard(airline: "JetStream Air", price: "$350")
                        FlightCard(airline: "Nimbus Airways", price: "$400")
                        FlightCard(airline: "SkyHop Airlines", price: "$380")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Hotels
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🏨 Where You'll Stay")
                            .font(.headline)
                            .fontWeight(.bold)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                HotelCard(
                                    image: "hotel1",
                                    name: "Aurora Grand NYC",
                                    rating: "🌟 4.3",
                                    price: "$250/Night"
                                )
                                HotelCard(
                                    image: "hotel2",
                                    name: "Skyline Retreat",
                                    rating: "🌟 4.8",
                                    price: "$400/Night"
                                )
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Plan Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🗺️ Itinerary Overview")
                            .font(.headline)
                            .fontWeight(.bold)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Day 1: Touchdown & Explore")
                                .font(.subheadline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Arrival in New York City")
                                    .font(.body)
                                    .fontWeight(.semibold)

                                Image("arrival")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(12)

                                Text("**Hotel Check-in:** Aurora Grand NYC")
                                Text("**Highlights:** Times Square, street food crawl")
                                Text("**Ticket Cost:** Free")

                                HStack {
                                    Spacer()
                                    Button(action: {}) {
                                        Image(systemName: "paperplane.fill")
                                            .padding()
                                            .background(Color.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Flight Card
struct FlightCard: View {
    let airline: String
    let price: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Airline: \(airline)")
                    .font(.subheadline)
                Text("Price: \(price)")
                    .font(.subheadline)
            }

            Spacer()

            Button(action: {
                print("Booking \(airline)")
            }) {
                Text("Book Now")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.black)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Hotel Card
struct HotelCard: View {
    let image: String
    let name: String
    let rating: String
    let price: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 100)
                .clipped()
                .cornerRadius(12)

            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            HStack {
                Text(rating)
                Text("💰 \(price)")
            }
            .font(.caption)
            .foregroundColor(.gray)

            HStack {
                Button(action: {}) {
                    Image(systemName: "bed.double.fill")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {}) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 160)
    }
}


#Preview{
    TripPlanView()
}
