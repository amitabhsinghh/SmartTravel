//
//  LoginView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI
import CoreData

struct LoginView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showRegister = false
    @State private var showPassword = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Welcome!")
                .font(.largeTitle).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            VStack(spacing: 16) {
                TextField("Email Address or Username", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(nil)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", text: $vm.password)
                        } else {
                            SecureField("Password", text: $vm.password)
                        }
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(nil)

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

                HStack {
                    Spacer()
                    Button("Forgot password?") {
                    }
                    .font(.footnote)
                }
            }
            .padding(.horizontal, 24)
            Button(action: vm.login) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 24)

            HStack(spacing: 4) {
                Text("Not a member?")
                Button("Register now") {
                    showRegister.toggle()
                }
            }
            .font(.footnote)

            Spacer()
        }
        .sheet(isPresented: $showRegister) {
            RegistrationView(vm: vm)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

#Preview {
    let ctx = PersistenceController.preview.container.viewContext
    LoginView(vm: AuthViewModel(context: ctx))
}
