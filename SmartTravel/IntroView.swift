//
//  IntroView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//


import SwiftUI
import UIKit

struct IntroView: View {
    var body: some View {
        ZStack {
            // Background Image (ensure "introPage" is in your assets)
            Image("introPage")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // White Card Container
                VStack(spacing: 24) {
                    // Title
                    Text("SmartTravel")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Subtitle
                    Text("Plan smarter. Travel easier.\nYour perfect trip, built just for you in minutes.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                    
                    // NavigationLink for Get Started (to go to AuthView)
                    NavigationLink(destination: AuthView()) {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 30)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(40, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    IntroView()
}

