//
//  TravelDateView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI


struct TravelDateView: View {

    let destination: String
    let party:       TravelParty
    let budget:      BudgetChoice

    @State private var fromDate: Date?
    @State private var toDate:   Date?

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Travel Dates")
                .font(.title2).bold()
                .padding(.top)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)

            CalendarGridView(fromDate: $fromDate, toDate: $toDate)
                .padding(.horizontal)

            Spacer()

            // SAFE NavigationLink: destination built only after tap
            NavigationLink {
                if let start = fromDate, let end = toDate {
                    ReviewTripView(
                        destination: destination,
                        startDate:   start,
                        endDate:     end,
                        party:       party,
                        budget:      budget
                    )
                } else {
                    // fallback (shouldn’t happen – button is disabled)
                    Text("Select both dates").foregroundColor(.red)
                }
            } label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((fromDate != nil && toDate != nil) ? Color.black : Color.gray)
                    .cornerRadius(14)
            }
            .disabled(fromDate == nil || toDate == nil)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }

    private var subtitle: String {
        switch (fromDate, toDate) {
        case (nil, _):         return "Tap the first date to begin"
        case (let f?, nil):    return "Select return date after \(formatted(f))"
        case (let f?, let t?): return "Traveling from \(formatted(f)) to \(formatted(t))"
        }
    }

    private func formatted(_ d: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: d)
    }
}

// MARK: – Calendar grid

struct CalendarGridView: View {
    @Binding var fromDate: Date?
    @Binding var toDate:   Date?

    @State private var currentMonth: Date = Date()
    private let calendar = Calendar.current

    private var daysInMonth: [Date] {
        let comps = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstOfMonth = calendar.date(from: comps)!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        return (0..<42).compactMap { offset in
            calendar.date(byAdding: .day,
                          value: offset - (weekday - 1),
                          to: firstOfMonth)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            // month changer
            HStack {
                Button("Previous") {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
                    }
                }
                Spacer()
                Text(monthYearString(from: currentMonth)).font(.headline)
                Spacer()
                Button("Next") {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
                    }
                }
            }
            .padding(.horizontal)

            // weekday labels
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { wd in
                    Text(wd.prefix(2))
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }

            // 7×6 day buttons
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7),
                      spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    let inMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    Button {
                        select(date)
                    } label: {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(width: 36, height: 36)
                            .background(backgroundColor(for: date))
                            .clipShape(Circle())
                            .foregroundColor(textColor(for: date, inMonth: inMonth))
                    }
                    .disabled(!inMonth)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // MARK: – helpers

    private func select(_ date: Date) {
        if fromDate == nil || (fromDate != nil && toDate != nil) {
            fromDate = date; toDate = nil
        } else if let start = fromDate, date >= start {
            toDate = date
        } else { // tapped before start date – reset range
            fromDate = date; toDate = nil
        }
    }

    private func backgroundColor(for date: Date) -> Color {
        guard let start = fromDate else { return .clear }
        if let end = toDate {
            if calendar.isDate(date, inSameDayAs: start) ||
               calendar.isDate(date, inSameDayAs: end) {
                return .black
            } else if date > start && date < end {
                return Color.black.opacity(0.15)
            }
        } else if calendar.isDate(date, inSameDayAs: start) {
            return .black
        }
        return .clear
    }

    private func textColor(for date: Date, inMonth: Bool) -> Color {
        if !inMonth { return .gray }
        if calendar.isDate(date, inSameDayAs: fromDate ?? Date()) ||
           calendar.isDate(date, inSameDayAs: toDate   ?? Date()) {
            return .white
        }
        return .black
    }

    private func monthYearString(from date: Date) -> String {
        let df = DateFormatter(); df.dateFormat = "MMMM yyyy"; return df.string(from: date)
    }
}

