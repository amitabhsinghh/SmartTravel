//
//  OnboardingViewModel.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//


import SwiftUI
import CoreData

class OnboardingViewModel: ObservableObject {
    @Published var hasOnboarded: Bool = false
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        checkOnboardingState()
    }

    private func checkOnboardingState() {
        let req: NSFetchRequest<OnboardingState> = OnboardingState.fetchRequest()
        req.fetchLimit = 1
        if let existing = (try? context.fetch(req))?.first {
            hasOnboarded = existing.hasOnboarded
        } else {
            hasOnboarded = false
        }
    }

    func completeOnboarding() {
        let req: NSFetchRequest<OnboardingState> = OnboardingState.fetchRequest()
        req.fetchLimit = 1

        let state = (try? context.fetch(req))?.first
            ?? OnboardingState(context: context)

        state.hasOnboarded = true

        do {
            try context.save()
            hasOnboarded = true
        } catch {
            print("❌ Couldn’t save onboarding state:", error)
        }
    }
}
