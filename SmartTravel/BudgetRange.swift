//
//  BudgetRange.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//



import SwiftUI


enum BudgetChoice: Hashable {
  case preset(BudgetRange)
  case custom(String)           // raw user input
}


enum BudgetRange: String, CaseIterable, Identifiable {
  case low    = "$500 – $1,000"
  case medium = "$1,000 – $2,000"
  case high   = "$2,000+"

  var id: String { rawValue }
  var subtitle: String {
    switch self {
    case .low:    return "A shoestring getaway"
    case .medium: return "Comfortable adventure"
    case .high:   return "All‑out splurge"
    }
  }
  var icon: String {
    switch self {
    case .low:    return "💵"
    case .medium: return "💰"
    case .high:   return "💎"
    }
  }
  var bgColor: Color {
    switch self {
    case .low:    return Color.green.opacity(0.3)
    case .medium: return Color.blue.opacity(0.3)
    case .high:   return Color.pink.opacity(0.3)
    }
  }
}

struct BudgetSelectionView: View {
  @State private var selectedPreset: BudgetRange?
  @State private var customBudget = ""
  let onContinue: (BudgetChoice) -> Void

  var body: some View {
    VStack(spacing: 24) {
      // Title
      VStack(spacing: 4) {
        Text("What’s your budget?")
          .font(.title2).bold()
        Text("Choose a range or enter your own amount")
          .font(.subheadline).foregroundColor(.secondary)
      }
      .padding(.top, 32)

      // Preset options
      ForEach(BudgetRange.allCases) { range in
        Button(action: {
          selectedPreset = range
          customBudget = ""        
        }) {
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text(range.rawValue).font(.headline)
              Text(range.subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Text(range.icon).font(.largeTitle)
            if selectedPreset == range {
              Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue).font(.title2)
            }
          }
          .padding()
          .background(range.bgColor)
          .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
      }

      // Manual entry
      VStack(alignment: .leading, spacing: 8) {
        Text("Or enter a custom budget:")
          .font(.subheadline)
          .foregroundColor(.secondary)
          .padding(.horizontal, 24)

        HStack {
          TextField("e.g. 1500", text: $customBudget)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onTapGesture {
              // clear any selected preset
              selectedPreset = nil
            }
          Text("$").foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
      }

      Spacer()

      // Continue
      Button(action: {
        if let preset = selectedPreset {
          onContinue(.preset(preset))
        } else if !customBudget.trimmingCharacters(in: .whitespaces).isEmpty {
          onContinue(.custom(customBudget))
        }
      }) {
        Text("Continue")
          .font(.headline)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(
            (selectedPreset != nil || !customBudget.isEmpty)
              ? Color.blue : Color.gray
          )
          .cornerRadius(12)
          .padding(.horizontal, 24)
      }
      .disabled(selectedPreset == nil && customBudget.isEmpty)
      .padding(.bottom, 32)
    }
    .background(Color(.systemGroupedBackground).ignoresSafeArea())
  }
}
