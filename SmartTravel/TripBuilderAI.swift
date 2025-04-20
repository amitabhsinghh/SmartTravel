//
//  TripBuilderAI.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//


import SwiftUI

@MainActor
extension TripBuilderViewModel {
    func buildItinerary() async throws -> [DayPlan] {
        guard let party = party,
              let budget = budget,
              let start  = fromDate,
              let end    = toDate else {
            throw NSError(domain: "TripBuilder", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Missing trip data"])
        }

        let df = DateFormatter(); df.dateFormat = "yyyy‑MM‑dd"
        let prompt = """
        Create a day‑by‑day travel itinerary in JSON.

        INPUT:
        destination: "\(destination)"
        dates: "\(df.string(from: start))" – "\(df.string(from: end))" (inclusive)
        travelers: "\(party.rawValue)"
        budget: "\(budgetSummary(budget))"

        REQUIRED JSON FORMAT (no extra keys, no markdown):

        [
          {
            "date": "YYYY-MM-DD",
            "title": "Short day title",
            "activities": [
              { "start": "HH:MM", "end": "HH:MM", "name": "Activity name" }
            ]
          },
          …
        ]

        Return ONLY the JSON array.
        """

        let raw = try await GeminiService.generateItinerary(prompt: prompt)
        let jsonString = raw
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```",    with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let data = Data(jsonString.utf8)
        let plans = try JSONDecoder().decode([DayPlan].self, from: data)
        return plans
    }

    private func budgetSummary(_ choice: BudgetChoice) -> String {
        switch choice {
        case .preset(let r): return r.rawValue
        case .custom(let v): return "$\(v)"
        }
    }
}
