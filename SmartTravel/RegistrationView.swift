//
//  RegistrationView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    private var canRegister: Bool {
        !vm.firstName.isEmpty &&
        !vm.lastName.isEmpty &&
        !vm.username.isEmpty &&
        !vm.email.isEmpty &&
        !vm.password.isEmpty &&
        vm.password == vm.confirmPassword
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        header

                        inputCard

                        signUpButton
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var header: some View {
        Text("Create Account")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var inputCard: some View {
        VStack(spacing: 16) {
            field(icon: "person.circle", placeholder: "First Name", text: $vm.firstName)
            field(icon: "person.circle.fill", placeholder: "Last Name", text: $vm.lastName)
            field(icon: "at", placeholder: "Username", text: $vm.username)
            field(icon: "envelope", placeholder: "Email Address", text: $vm.email, keyboard: .emailAddress)
            secureField(icon: "lock", placeholder: "Password", text: $vm.password)
            secureField(icon: "lock.rotation", placeholder: "Confirm Password", text: $vm.confirmPassword)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    private var signUpButton: some View {
        Button(action: {
            vm.register()
            if vm.isLoggedIn { dismiss() }
        }) {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(canRegister ? Color.green : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!canRegister)
    }

    private func field(icon: String,
                       placeholder: String,
                       text: Binding<String>,
                       keyboard: UIKeyboardType = .default) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color(.secondarySystemFill))
        .cornerRadius(8)
    }

    private func secureField(icon: String,
                             placeholder: String,
                             text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            SecureField(placeholder, text: text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color(.secondarySystemFill))
        .cornerRadius(8)
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    RegistrationView(vm: AuthViewModel(context: ctx))
}
