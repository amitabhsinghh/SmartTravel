//
//  ActivityCard.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.


import SwiftUI

struct ActivityCard: View {
    let event: Event

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // time column
            VStack(alignment: .trailing) {
                Text(event.start)
                    .bold()
                if let end = event.end {
                    Text(end)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 80)

            // details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.body)
                    .bold()
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let price = event.price {
                    Text(price)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
