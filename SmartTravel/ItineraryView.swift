//
//  ItineraryView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//

import SwiftUI

struct ItineraryView: View {
    let days: [DayPlan]

    var body: some View {
        List {
            ForEach(days) { day in
                Section(header: Text("\(day.date) – \(day.title)").font(.headline)) {
                    ForEach(day.events) { event in
                        EventRowView(event: event)
                    }
                }
            }
        }
        .navigationTitle("Your Trip")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventRowView: View {
    let event: Event

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .trailing) {
                Text(event.start)
                    .bold()
                if let end = event.end {
                    Text(end)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 56)

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
        }
        .padding(.vertical, 4)
    }
}
