//
//  SelectTravelersView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct SelectTravelersView: View {
    @State private var selectedOption: String = ""
    
    struct TravelerOption: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let emoji: String
        let color: Color
    }
    
    let travelerOptions: [TravelerOption] = [
        .init(title: "Just Me", subtitle: "Solo explorer vibes 🌍", emoji: "🧍‍♂️", color: Color.pink.opacity(0.2)),
        .init(title: "A Couple", subtitle: "Tandem adventures 💞", emoji: "💑", color: Color.purple.opacity(0.2)),
        .init(title: "Family", subtitle: "All together now 🧳", emoji: "👨‍👩‍👧‍👦", color: Color.green.opacity(0.2)),
        .init(title: "Friends", subtitle: "Thrill seekers squad 🎉", emoji: "🕺💃", color: Color.yellow.opacity(0.2))
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 24) {
                Spacer().frame(height: 30)
                
                // Header
                VStack(spacing: 8) {
                    Text("Who's joining the adventure?")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Let us know who's coming along")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
                // Option Cards
                VStack(spacing: 16) {
                    ForEach(travelerOptions) { option in
                        Button(action: {
                            withAnimation(.easeInOut) {
                                selectedOption = option.title
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(option.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Text(option.subtitle)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(option.emoji)
                                    .font(.title)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(option.color)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedOption == option.title ? Color.black : Color.clear, lineWidth: 2)
                                    )
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                // NavigationLink to TravelDateView
                NavigationLink(destination: TravelDateView()) {
                    Text("Next")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? geo.safeAreaInsets.bottom : 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SelectTravelersView()
}
