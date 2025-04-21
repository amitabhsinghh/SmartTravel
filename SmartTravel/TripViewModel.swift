//
//  TripViewModel.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.


import Foundation
import SwiftUI

@MainActor
class TripViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var generatedPlans: [DayPlan] = []
    @Published var errorMsg: String?
    @Published var showResult = false

    private var cancelFlag = false

    func generate(from info: ReviewTripData) async {
        isLoading = true
        cancelFlag = false

        do {
            let plans = try await GeminiBuilder.build(from: info, cancelFlag: { self.cancelFlag })
            if !cancelFlag {
                self.generatedPlans = plans
                self.showResult = true
            }
        } catch {
            if !cancelFlag {
                self.errorMsg = error.localizedDescription
            }
        }

        isLoading = false
    }

    func cancelGeneration() {
        cancelFlag = true
        isLoading = false
    }
}
