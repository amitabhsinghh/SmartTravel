//
//  ReviewTripView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI

/// Bundle up your wizard selections
struct ReviewTripData {
    let destination: String
    let startDate:   Date
    let endDate:     Date
    let party:       TravelParty
    let budget:      BudgetChoice
}

struct ReviewTripView: View {
    let destination: String
    let startDate:   Date
    let endDate:     Date
    let party:       TravelParty
    let budget:      BudgetChoice

    @EnvironmentObject private var viewModel: TripViewModel

    private var dateRangeText: String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        let span = (Calendar.current
                        .dateComponents([.day],
                                        from: startDate,
                                        to: endDate).day ?? 0) + 1
        return "\(df.string(from: startDate)) to \(df.string(from: endDate)) (\(span) day\(span>1 ? "s":""))"
    }

    private var budgetInfo: (text: String, icon: String) {
        switch budget {
        case .preset(let r): return (r.rawValue, r.icon)
        case .custom(let s): return ("$\(s)", "💵")
        }
    }

    var body: some View {
        ZStack {
            // ── Review UI ─────────────────────────────────
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Review Your Trip")
                        .font(.title2).bold()
                    Text("Please review your selection before generating your trip.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 32)

                VStack(spacing: 12) {
                    row(icon: Image(systemName: "mappin.and.ellipse").foregroundColor(.red),
                        label: "DESTINATION",   value: destination)
                    row(icon: Image(systemName: "calendar").foregroundColor(.blue),
                        label: "TRAVEL DATES",  value: dateRangeText)
                    row(icon: Text(party.icon).font(.title2),
                        label: "TRAVEL GROUP",  value: party.rawValue)
                    row(icon: Text(budgetInfo.icon).font(.title2),
                        label: "BUDGET",        value: budgetInfo.text)
                }
                .padding(.horizontal)

                Spacer()

                Button {
                    let info = ReviewTripData(
                        destination: destination,
                        startDate:   startDate,
                        endDate:     endDate,
                        party:       party,
                        budget:      budget
                    )
                    Task { await viewModel.generate(from: info) }
                } label: {
                    Text("Build My Trip")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())

            // ── Hidden navigation links ────────────────────
            NavigationLink(
                destination: LoadingView(viewModel: viewModel),
                isActive:   $viewModel.isLoading
            ) { EmptyView() }
            .hidden()

            NavigationLink(
              destination:
                ItineraryResultsView(
                  trip: nil,
                  initialDestination: destination,
                  viewModel: viewModel
                ),
              isActive: $viewModel.showResult
            ) { EmptyView() }
            .hidden()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.showResult)
        .alert("Error", isPresented: .constant(viewModel.errorMsg != nil)) {
            Button("OK") { viewModel.errorMsg = nil }
        } message: {
            Text(viewModel.errorMsg ?? "")
        }
    }

    @ViewBuilder
    private func row<Icon: View>(
        icon: Icon,
        label: String,
        value: String
    ) -> some View {
        HStack(spacing: 16) {
            icon
                .frame(width: 36, height: 36)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
