//
//  TravelParty.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//



import SwiftUI

enum TravelParty: String, CaseIterable, Identifiable {
    case solo      = "Just Me"
    case couple    = "A Couple"
    case family    = "Family"
    case friends   = "Friends"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .solo:    return "Solo explorer vibes 🌎"
        case .couple:  return "Tandem adventures 💞"
        case .family:  return "All together now 🧳"
        case .friends: return "Thrill seekers squad 🎉"
        }
    }

    var icon: String {
        switch self {
        case .solo:    return "🧍"
        case .couple:  return "👫"
        case .family:  return "👨‍👩‍👧‍👦"
        case .friends: return "🕺💃"
        }
    }

    var bgColor: Color {
        switch self {
        case .solo:    return Color.pink.opacity(0.3)
        case .couple:  return Color.purple.opacity(0.3)
        case .family:  return Color.green.opacity(0.3)
        case .friends: return Color.yellow.opacity(0.3)
        }
    }
}

struct SelectTravelersView: View {
    @State private var selected: TravelParty?
    let onContinue: (TravelParty) -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 4) {
                Text("Who's joining the adventure?")
                    .font(.title2)
                    .bold()
                Text("Let us know who's coming along")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 32)

            // Options
            ForEach(TravelParty.allCases) { party in
                Button(action: {
                    selected = party
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(party.rawValue)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(party.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(party.icon)
                            .font(.largeTitle)
                        if selected == party {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(party.bgColor)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            }

            Spacer()

            // Continue button
            Button(action: {
                if let sel = selected {
                    onContinue(sel)
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selected != nil ? Color.blue : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
            }
            .disabled(selected == nil)
            .padding(.bottom, 32)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

