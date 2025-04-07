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
            // Top Navigation Bar with Back Button
            HStack {
                Button(action: { dismiss() }) {
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
            Text("Where do you want to go?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Search Field
            TextField("Enter destination", text: $searchText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .padding(.horizontal)
            
            Spacer()
            
            // NavigationLink to SelectTravelersView
            NavigationLink(destination: SelectTravelersView()) {
                Text("Next")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchDestinationView()
}
