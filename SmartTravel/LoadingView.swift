//
//  LoadingView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.


import SwiftUI

/// Animated “building trip…” screen that appears while the itinerary
/// is being generated.
struct LoadingView: View {
    @ObservedObject var viewModel: TripViewModel

    private let travelTips = [
        "Pro Tip • Pack a portable charger for your devices",
        "Local Insight • Learn 3 basic phrases in the local language",
        "Money Saver • Withdraw cash at airport ATMs for best rates",
        "Comfort Tip • Compression socks help on long flights",
        "Tech Tip • Download Google Translate offline packs",
        "Safety Tip • Email yourself copies of important documents"
    ]

    @State private var currentTip    = ""
    @State private var progress      = 0.0
    @State private var airplaneAngle = 0.0
    @State private var tipTimer      : Timer?

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 4) {
                Text("Crafting Your")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("Dream Trip")
                    .font(.system(.largeTitle, design: .rounded).bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .teal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding(.top, 40)

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(Color(.systemGray5))
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .foregroundStyle(.blue)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "airplane")
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)
                        .rotationEffect(.degrees(airplaneAngle))
                        .offset(
                            x: 50 * cos(airplaneAngle * .pi / 180),
                            y: 50 * sin(airplaneAngle * .pi / 180)
                        )
                }
                .frame(width: 120, height: 120)
                .padding(.vertical, 16)

                Text("\(Int(progress * 100))% Complete")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                Text("TRAVEL TIP")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.blue))

                Text(currentTip)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                    )
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(role: .destructive) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                viewModel.cancelGeneration()
            } label: {
                Text("Cancel")
                    .padding(.vertical, 6)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .onAppear { startAnimations() }
        .onDisappear { tipTimer?.invalidate() }
    }

    private func startAnimations() {
        currentTip = travelTips.randomElement() ?? "Enjoy your adventure!"
        withAnimation(.linear(duration: 2.5)) { progress = 1 }
        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
            airplaneAngle = 360
        }
        tipTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.35)) {
                currentTip = travelTips.randomElement() ?? currentTip
            }
        }
    }
}
