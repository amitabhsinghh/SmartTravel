//
//  NoTripView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//

import SwiftUI

struct NoTripView: View {
    var body: some View {
        TabView {
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                
                Text("No Trips Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Time to plan your next journey.\nThe world is waiting for you to explore!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                
                // NavigationLink to SearchDestinationView
                NavigationLink(destination: SearchDestinationView()) {
                    Text("Start New Trip")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 50)
                        .background(Color.black)
                        .cornerRadius(30)
                }
                Spacer()
            }
            .tabItem {
                Label("My Trip", systemImage: "mappin.and.ellipse")
            }
            
            Text("Discover")
                .tabItem {
                    Label("Discover", systemImage: "globe")
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    NoTripView()
}
