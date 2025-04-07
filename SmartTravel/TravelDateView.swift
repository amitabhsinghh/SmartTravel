//
//  TravelDateView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//
//
//import SwiftUI
//
//struct TravelDateView: View {
//    @State private var fromDate: Date? = nil
//    @State private var toDate: Date? = nil
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Select Travel Dates")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top)
//
//            Text(subtitle)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            CalendarGridView(fromDate: $fromDate, toDate: $toDate)
//
//            Spacer()
//
//            Button(action: {
//                print("From: \(String(describing: fromDate))")
//                print("To: \(String(describing: toDate))")
//            }) {
//                Text("Continue")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(fromDate != nil && toDate != nil ? Color.black : Color.gray)
//                    .cornerRadius(14)
//            }
//            .disabled(fromDate == nil || toDate == nil)
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//        }
//        .padding(.horizontal)
//    }
//
//    var subtitle: String {
//        if let from = fromDate, let to = toDate {
//            return "Traveling from \(formatted(from)) to \(formatted(to))"
//        } else if let from = fromDate {
//            return "Select return date after \(formatted(from))"
//        } else {
//            return "Tap the first date to begin"
//        }
//    }
//
//    func formatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//}
//
//struct CalendarGridView: View {
//    @Binding var fromDate: Date?
//    @Binding var toDate: Date?
//
//    private let calendar = Calendar.current
//    private let currentMonth: Date
//    private let daysInMonth: [Date]
//
//    init(fromDate: Binding<Date?>, toDate: Binding<Date?>) {
//        self._fromDate = fromDate
//        self._toDate = toDate
//        self.currentMonth = Date()
//
//        let calendar = Calendar.current
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self.currentMonth))!
//        self.daysInMonth = (0..<42).compactMap { offset in
//            calendar.date(byAdding: .day, value: offset - calendar.component(.weekday, from: startOfMonth) + 1, to: startOfMonth)
//        }
//    }
//
//
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack {
//                ForEach(0..<calendar.shortWeekdaySymbols.count, id: \.self) { index in
//                    Text(String(calendar.shortWeekdaySymbols[index].prefix(2)))
//                        .font(.caption)
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.gray)
//                }
//            }
//
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
//                ForEach(daysInMonth, id: \.self) { date in
//                    let isInMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
//
//                    Button(action: {
//                        handleDateSelection(date)
//                    }) {
//                        Text("\(calendar.component(.day, from: date))")
//                            .frame(width: 36, height: 36)
//                            .background(backgroundColor(for: date))
//                            .clipShape(Circle())
//                            .foregroundColor(textColor(for: date, inMonth: isInMonth))
//                    }
//                    .disabled(!isInMonth)
//                }
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(16)
//    }
//
//    private func handleDateSelection(_ date: Date) {
//        if fromDate == nil || (fromDate != nil && toDate != nil) {
//            fromDate = date
//            toDate = nil
//        } else if let start = fromDate, date >= start {
//            toDate = date
//        } else {
//            fromDate = date
//            toDate = nil
//        }
//    }
//
//    private func backgroundColor(for date: Date) -> Color {
//        guard let from = fromDate else { return .clear }
//
//        if let to = toDate {
//            if calendar.isDate(date, inSameDayAs: from) || calendar.isDate(date, inSameDayAs: to) {
//                return .black
//            } else if date > from && date < to {
//                return Color.black.opacity(0.15)
//            }
//        } else if calendar.isDate(date, inSameDayAs: from) {
//            return .black
//        }
//
//        return .clear
//    }
//
//    private func textColor(for date: Date, inMonth: Bool) -> Color {
//        if !inMonth { return .gray }
//
//        if calendar.isDate(date, inSameDayAs: fromDate ?? Date()) ||
//            calendar.isDate(date, inSameDayAs: toDate ?? Date()) {
//            return .white
//        }
//
//        return .black
//    }
//}
//
//#Preview {
//    TravelDateView()
//}

import SwiftUI

struct TravelDateView: View {
    @State private var fromDate: Date? = nil
    @State private var toDate: Date? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Travel Dates")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            CalendarGridView(fromDate: $fromDate, toDate: $toDate)
            
            Spacer()
            
            // NavigationLink to ReviewTripView (passing selected dates)
            NavigationLink(destination: ReviewTripView(fromDate: fromDate, toDate: toDate)) {
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
    
    var subtitle: String {
        if let from = fromDate, let to = toDate {
            return "Traveling from \(formatted(from)) to \(formatted(to))"
        } else if let from = fromDate {
            return "Select return date after \(formatted(from))"
        } else {
            return "Tap the first date to begin"
        }
    }
    
    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CalendarGridView: View {
    @Binding var fromDate: Date?
    @Binding var toDate: Date?
    
    @State private var currentMonth: Date = Date()
    private let calendar = Calendar.current
    
    private var daysInMonth: [Date] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        return (0..<42).compactMap { offset in
            calendar.date(byAdding: .day, value: offset - calendar.component(.weekday, from: startOfMonth) + 1, to: startOfMonth)
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Month/Year Header + Navigation
            HStack {
                Button("Previous") {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }
                Spacer()
                Text(monthYearString(from: currentMonth))
                    .font(.headline)
                Spacer()
                Button("Next") {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }
            }
            .padding(.horizontal)
            
            // Weekday Headers
            HStack {
                ForEach(0..<calendar.shortWeekdaySymbols.count, id: \.self) { index in
                    Text(String(calendar.shortWeekdaySymbols[index].prefix(2)))
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            
            // Date Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    let isInMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    Button(action: {
                        handleDateSelection(date)
                    }) {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(width: 36, height: 36)
                            .background(backgroundColor(for: date))
                            .clipShape(Circle())
                            .foregroundColor(textColor(for: date, inMonth: isInMonth))
                    }
                    .disabled(!isInMonth)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func handleDateSelection(_ date: Date) {
        if fromDate == nil || (fromDate != nil && toDate != nil) {
            fromDate = date
            toDate = nil
        } else if let start = fromDate, date >= start {
            toDate = date
        } else {
            fromDate = date
            toDate = nil
        }
    }
    
    private func backgroundColor(for date: Date) -> Color {
        guard let from = fromDate else { return .clear }
        
        if let to = toDate {
            if calendar.isDate(date, inSameDayAs: from) || calendar.isDate(date, inSameDayAs: to) {
                return .black
            } else if date > from && date < to {
                return Color.black.opacity(0.15)
            }
        } else if calendar.isDate(date, inSameDayAs: from) {
            return .black
        }
        return .clear
    }
    
    private func textColor(for date: Date, inMonth: Bool) -> Color {
        if !inMonth { return .gray }
        if calendar.isDate(date, inSameDayAs: fromDate ?? Date()) ||
            calendar.isDate(date, inSameDayAs: toDate ?? Date()) {
            return .white
        }
        return .black
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    TravelDateView()
}
