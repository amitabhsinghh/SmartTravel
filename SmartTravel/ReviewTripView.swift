//
//  ReviewTripView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct ReviewTripView: View {
    let destination = "New York, NY, USA"
    let fromDate = "04 Aug"
    let toDate = "07 Aug"
    let duration = "4 Days"
    let group = "Family"
    let budget = "Moderate"

    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 30)

            // Header
            VStack(spacing: 8) {
                Text("Review Your Trip")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Please review your selection before generating your trip.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            // Trip Details
            VStack(spacing: 16) {
                ReviewRow(icon: "📍", color: .pink.opacity(0.15), title: "Destination", value: destination)
                ReviewRow(icon: "🗓️", color: .blue.opacity(0.15), title: "Travel Dates", value: "\(fromDate) to \(toDate) (\(duration))")
                ReviewRow(icon: "🧑‍🤝‍🧑", color: .green.opacity(0.15), title: "Travel Group", value: group)
                ReviewRow(icon: "💰", color: .yellow.opacity(0.2), title: "Budget", value: budget)
            }
            .padding(.horizontal)

            Spacer()

            // Continue Button
            Button(action: {
                print("Trip confirmed — generate itinerary!")
            }) {
                Text("Build My Trip")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}

struct ReviewRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                Text(icon)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)

                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}


#Preview{
    ReviewTripView()
}
