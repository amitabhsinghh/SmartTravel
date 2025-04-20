//
//  ReviewTripView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI

struct ReviewTripView: View {
    // ── Input from previous screens ──
    let destination: String
    let startDate:   Date
    let endDate:     Date
    let party:       TravelParty
    let budget:      BudgetChoice

    // ── Local state ──
    @State private var isLoading = false
    @State private var plans: [DayPlan] = []
    @State private var showItinerary = false
    @State private var errorMsg: String?

    // MARK: – Derived display text
    private var dateRangeText: String {
        let df = DateFormatter(); df.dateFormat = "dd MMM"
        let span = (Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0) + 1
        return "\(df.string(from: startDate)) to \(df.string(from: endDate)) (\(span) day\(span > 1 ? "s" : ""))"
    }

    private var budgetInfo: (text: String, icon: String) {
        switch budget {
        case .preset(let r): return (r.rawValue, r.icon)
        case .custom(let s): return ("$\(s)", "💵")
        }
    }

    var body: some View {
        VStack(spacing: 24) {

            // HEADER
            VStack(spacing: 8) {
                Text("Review Your Trip").font(.title2).bold()
                Text("Please review your selection before generating your trip.")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            .padding(.top, 32)

            // DETAILS
            VStack(spacing: 12) {
                row(Image(systemName: "mappin.and.ellipse").foregroundColor(.red),
                    "DESTINATION", destination)

                row(Image(systemName: "calendar").foregroundColor(.blue),
                    "TRAVEL DATES", dateRangeText)

                row(Text(party.icon).font(.title2),
                    "TRAVEL GROUP", party.rawValue)

                row(Text(budgetInfo.icon).font(.title2),
                    "BUDGET", budgetInfo.text)
            }
            .padding(.horizontal)

            Spacer()

            // BUILD BUTTON
            Button(action: generateItinerary) {
                if isLoading {
                    ProgressView().progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Build My Trip")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(isLoading ? Color.gray : Color.black)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(isLoading)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showItinerary) {
            ItineraryView(days: plans)
        }
        .alert("Error", isPresented: .constant(errorMsg != nil)) {
            Button("OK") { errorMsg = nil }
        } message: { Text(errorMsg ?? "") }
    }

    // MARK: – Networking

    private func generateItinerary() {
        guard !isLoading else { return }
        isLoading = true

        Task {
            do {
                plans = try await buildStructuredPlan()
                showItinerary = true
            } catch {
                errorMsg = error.localizedDescription
            }
            isLoading = false
        }
    }

    /// Calls Gemini; converts strict JSON → `[DayPlan]`
    private func buildStructuredPlan() async throws -> [DayPlan] {
        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
        let prompt = """
        You are a JSON‑ONLY API. Respond with **nothing but** a valid JSON array.

        Generate a detailed, day‑by‑day travel itinerary for:

        • destination: "\(destination)"
        • dates: "\(df.string(from: startDate))" – "\(df.string(from: endDate))"
        • travelers: "\(party.rawValue)"
        • budget: "\(budgetInfo.text)"

        Each array element must have exactly these keys:
          "date"       – string "YYYY-MM-DD"
          "title"      – short day title
          "activities" – array of objects {
             "start": "HH:MM",
             "end":   "HH:MM",
             "name":  "Activity name"
          }

        Return ONLY the JSON array, with no markdown fences or commentary.
        """

        let raw: String
        do {
            raw = try await GeminiService.generateItinerary(prompt: prompt, debugPrint: true)
        } catch let GeminiService.GeminiError.http(code, body) {
            throw NSError(domain: "HTTP", code: code, userInfo: [
                NSLocalizedDescriptionKey: "Gemini HTTP \(code):\n\(body)"
            ])
        }

        let cleaned = raw
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let json: String
        if let start = cleaned.firstIndex(of: "["),
           let end   = cleaned.lastIndex(of: "]"),
           start < end {
            json = String(cleaned[start...end])
        } else {
            json = cleaned
        }

        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "Parse", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Invalid UTF‑8 from Gemini"
            ])
        }

        do {
            return try JSONDecoder().decode([DayPlan].self, from: data)
        } catch {
            let preview = json.prefix(800)
            throw NSError(domain: "Parse", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to decode JSON:\n\n\(preview)"
            ])
        }
    }

    // MARK: – UI helpers

    @ViewBuilder
    private func row<Icon: View>(_ icon: Icon,
                                 _ label: String,
                                 _ value: String) -> some View {
        HStack(spacing: 16) {
            icon.frame(width: 36, height: 36)
                .background(Color(.systemGray6)).cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundColor(.secondary)
                Text(value).font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
