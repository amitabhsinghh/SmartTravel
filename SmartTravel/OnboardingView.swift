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
      // 1) Background image
      Image("introPage")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      // 2) Semi‑transparent dark overlay for contrast
      Color.black.opacity(0.4)
        .ignoresSafeArea()

      // 3) Content on top
      VStack(spacing: 24) {
        Spacer()

        VStack(spacing: 12) {
          Text("Smart Travel")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)

          Text("Effortlessly plan your next adventure, get personalized itineraries with AI travel insights.")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 40)
        }

        Spacer()

        // 4) Button with a max width
        Button(action: onComplete) {
          Text("Get Started")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .frame(maxWidth: 240)            // ← limit the width here
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

