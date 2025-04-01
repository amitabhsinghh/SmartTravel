//
//  SearchDestinationView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI

struct SearchDestinationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Top navigation bar with back button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }

                Text("Search")
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal)

            // Heading
            Text("Search Your Destination")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)

            // Search field
            TextField("Search Place", text: $searchText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true) // custom back button
    }
}

#Preview {
    SearchDestinationView()
}
