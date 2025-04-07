//
//  MyTripsView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//
import SwiftUI

struct MyTripsView: View {
    var body: some View {
        TabView {
            // --- My Trip Tab ---
            NavigationView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("My Trip")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            print("Add new trip")
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Trip Card
                    VStack(alignment: .leading, spacing: 12) {
                        Image("dummy")
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(16)
                        
                        HStack {
                            Text("04 Aug 2024")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Label("Family", systemImage: "car.fill")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            print("See your plan tapped")
                        }) {
                            Text("See Your Plan")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Mini Summary
                    HStack(spacing: 12) {
                        Image("dummy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading) {
                            Text("04 Aug 2024")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Text("Travelling: Family")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
            .tabItem {
                Label("My Trip", systemImage: "mappin.and.ellipse")
            }
            
            // --- Discover Tab Placeholder ---
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "globe")
                }
            
            // --- Profile Tab Placeholder ---
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

// MARK: - Discover View Placeholder
struct DiscoverView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .font(.system(size: 40))
                .padding(.bottom, 10)
            Text("Discover")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
        }
    }
}

// MARK: - Profile View Placeholder
struct ProfileView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.system(size: 40))
                .padding(.bottom, 10)
            Text("Profile")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
        }
    }
}


#Preview {
    MyTripsView()
}
