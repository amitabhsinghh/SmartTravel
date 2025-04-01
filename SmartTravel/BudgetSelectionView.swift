//
//  BudgetSelectionView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct BudgetSelectionView: View {
    @State private var selectedBudget: String = ""

    struct BudgetOption: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let icon: String
        let color: Color
    }

    let options: [BudgetOption] = [
        .init(title: "Budget", description: "Smart & cost-effective 🪙", icon: "dollarsign.circle.fill", color: .mint.opacity(0.2)),
        .init(title: "Moderate", description: "Balanced and comfortable ⚖️", icon: "scalemass", color: .blue.opacity(0.15)),
        .init(title: "Luxury", description: "Go all out in style 💎", icon: "sparkles", color: .purple.opacity(0.15))
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 30)

            VStack(spacing: 6) {
                Text("What’s Your Travel Style?")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Select your trip spending preference")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            VStack(spacing: 16) {
                ForEach(options) { option in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selectedBudget = option.title
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option.title)
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)

                                Text(option.description)
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: option.icon)
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(option.color)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedBudget == option.title ? Color.black : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                    .padding(.horizontal)
                    .scaleEffect(selectedBudget == option.title ? 1.03 : 1.0)
                }
            }

            Spacer()

            Button(action: {
                print("Selected budget: \(selectedBudget)")
            }) {
                Text("Continue")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedBudget != "" ? Color.black : Color.gray)
                    .cornerRadius(14)
            }
            .disabled(selectedBudget == "")
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    BudgetSelectionView()
}
