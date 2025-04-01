//
//  NoTripView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct NoTripView: View {
    var body: some View {
        TabView {
            VStack(spacing: 24) {
                Spacer()

                // Location icon
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)

                // Title
                Text("No Trips Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                // Subtitle
                Text("Time to plan your next journey.\nThe world is waiting for you to explore!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)

                // Action button
                Button(action: {
                    // Start new trip action
                }) {
                    Text("Start New Trip")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 50)
                        .background(Color.black)
                        .cornerRadius(30)
                }

                Spacer()
            }
            .tabItem {
                Label("My Trip", systemImage: "mappin.and.ellipse")
            }

            // Discover Tab Placeholder
            Text("Discover")
                .tabItem {
                    Label("Discover", systemImage: "globe")
                }

            // Profile Tab Placeholder
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    NoTripView()
}
