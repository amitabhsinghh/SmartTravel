//
//  GeminiBuilder.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.

import Foundation

enum GeminiBuilder {
    static func build(
        from input: ReviewTripData,
        cancelFlag: @escaping () -> Bool
    ) async throws -> [DayPlan] {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        let prompt = """
        You are a travel planning API. Return ONLY a clean JSON array.

        INPUT:
        • Destination: "\(input.destination)"
        • Dates: "\(df.string(from: input.startDate))" – "\(df.string(from: input.endDate))"
        • Travelers: "\(input.party.rawValue)"
        • Budget: "\(formatBudget(input.budget))"

        FORMAT:
        [
          {
            "date": "YYYY-MM-DD",
            "title": "Short title",
            "events": [
              {
                "start": "HH:MM",
                "end": "HH:MM",
                "name": "Some Event",
                "type": "hotel|activity|meal",
                "location": "Address",
                "price": "$xx"    // optional
              },
              …
            ]
          },
          …
        ]
        """

        let raw = try await GeminiService.generateItinerary(prompt: prompt, debugPrint: true)
        guard !cancelFlag() else { return [] }

        // strip any Markdown fences
        let cleaned = raw
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```",    with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // extract the [...] substring
        let jsonSlice: String
        if let start = cleaned.firstIndex(of: "["),
           let end   = cleaned.lastIndex(of: "]"),
           start < end {
            jsonSlice = String(cleaned[start...end])
        } else {
            jsonSlice = cleaned
        }

        // Normalize any legacy "activities" key
        let normalized = jsonSlice.replacingOccurrences(of: "\"activities\":", with: "\"events\":")

        guard let data = normalized.data(using: .utf8) else {
            throw NSError(
                domain: "ParseError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 in JSON"]
            )
        }

        do {
            return try JSONDecoder().decode([DayPlan].self, from: data)
        } catch {
            let preview = normalized.prefix(800)
            throw NSError(
                domain: "ParseError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "cannot parse response:\n\n\(preview)"]
            )
        }
    }

    private static func formatBudget(_ choice: BudgetChoice) -> String {
        switch choice {
        case .preset(let r):   return r.rawValue
        case .custom(let amt): return "$\(amt)"
        }
    }
}
