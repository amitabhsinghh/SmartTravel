//
//  OnboardingView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//

import SwiftUI

struct OnboardingView: View {
  let onComplete: () -> Void

  var body: some View {
    ZStack {
      // Background
      Image("introPage")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      // Dark overlay for contrast
      Color.black.opacity(0.4)
        .ignoresSafeArea()

      // Content
      VStack(spacing: 30) {
        Spacer()

        // Title
        Text("Smart Travel")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)

        // ► Split the subtitle into multiple Texts
        VStack(spacing: 6) {
          Text("Effortlessly plan your next adventure,")
          Text("get personalized itineraries")
          Text("with AI travel insights.")
        }
        .font(.body)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
        .padding(.horizontal, 40)

        Spacer()

        // Button
        Button(action: onComplete) {
          Text("Get Started")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .frame(maxWidth: 240)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding(.bottom, 50)
      }
    }
  }
}



#Preview {
  OnboardingView(onComplete: { })
}

