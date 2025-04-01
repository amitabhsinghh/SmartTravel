//
//  TripLoadingView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct TripLoadingView: View {
    @State private var float = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Headline
            VStack(spacing: 10) {
                Text("Your Dream Trip Is On the Way...")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Sit back and relax while we build your perfect itinerary 🗺️")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            // Fun animated image
            Image("planeIcon") // Replace with your actual asset name
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .offset(y: float ? -10 : 10)
                .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: float)
                .onAppear {
                    float = true
                }

            // Optional Tip or Fun Fact
            Text("🌟 Travel Tip: Don’t forget to pack your chargers!")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            // Custom Loading Spinner
            VStack(spacing: 8) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.3)

                Text("Building your trip...")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
}


#Preview {
    TripLoadingView()
}
