//
//  DestinationSearchViewModel.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//



import SwiftUI

class DestinationSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var recentSearches: [String] = []

    private let defaultsKey = "recentSearches"

    init() {
        load()
    }

    private func load() {
        recentSearches = UserDefaults.standard.stringArray(forKey: defaultsKey) ?? []
    }

    private func save() {
        UserDefaults.standard.setValue(recentSearches, forKey: defaultsKey)
    }

    func record(_ destination: String) {
        let trimmed = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        // remove existing match
        recentSearches.removeAll { $0.caseInsensitiveCompare(trimmed) == .orderedSame }
        // insert at front
        recentSearches.insert(trimmed, at: 0)
        // keep only 3
        if recentSearches.count > 3 {
            recentSearches = Array(recentSearches.prefix(3))
        }
        save()
    }
}

struct DestinationSearchView: View {
    @StateObject private var vm = DestinationSearchViewModel()
    let onSearch: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text("Search Your Destination")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("New York", text: $vm.query, onCommit: submit)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // Recent searches
                if !vm.recentSearches.isEmpty {
                    Text("Recent Searches")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    ForEach(vm.recentSearches, id: \.self) { item in
                        Button(action: { select(item) }) {
                            HStack {
                                Text(item)
                                Spacer()
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("")      // we already show our own title
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func submit() {
        let dest = vm.query
        vm.record(dest)
        onSearch(dest)
    }

    private func select(_ item: String) {
        vm.record(item)
        onSearch(item)
    }
}
