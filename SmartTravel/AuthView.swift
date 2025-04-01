//
//  AuthView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 3/29/25.
//
import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            // Headings
            VStack(alignment: .leading, spacing: 8) {
                Text("Let's get you signed in")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Welcome Back")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)

                Text("You've been missed!")
                    .font(.body)
                    .foregroundColor(.gray)
            }

            // Form Fields
            VStack(alignment: .leading, spacing: 16) {
                Text("Email")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                TextField("Enter Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))

                Text("Password")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                SecureField("Enter Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
            }

            // Primary Sign In Button
            Button(action: {
                // Handle sign in
            }) {
                Text("Sign In")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
            }

            // Secondary Create Account Button
            Button(action: {
                // Navigate to sign-up screen or switch UI
            }) {
                Text("Create Account")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 50)
    }
}


#Preview {
    AuthView()
}
