//
//  RegistrationView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//


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
            VStack(spacing: 16) {
                Text("Create Account")
                    .font(.largeTitle).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 12) {
                        TextField("First Name", text: $vm.firstName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .textContentType(nil)

                        TextField("Last Name", text: $vm.lastName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .textContentType(nil)

                        TextField("username", text: $vm.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.asciiCapable)
                            .textContentType(nil)
                            .onChange(of: vm.username) { vm.username = $0.lowercased() }

                        TextField("Email Address", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textContentType(nil)

                        NoAutofillTextField(
                            text: $vm.password,
                            placeholder: "Password",
                            isSecure: true
                        )

                        NoAutofillTextField(
                            text: $vm.confirmPassword,
                            placeholder: "Confirm Password",
                            isSecure: true
                        )
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }

                Button {
                    vm.register()
                    if vm.isLoggedIn { dismiss() }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canRegister ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!canRegister)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
