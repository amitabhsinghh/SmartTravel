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
                    ForEach(day.activities) { act in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .trailing) {
                                Text(act.start).bold()
                                Text(act.end).font(.caption)
                            }
                            .frame(width: 56)

                            Text(act.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Your Trip")
        .navigationBarTitleDisplayMode(.inline)
    }
}
