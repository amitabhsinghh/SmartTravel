//
//  ProfileView.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: AuthViewModel

    @State private var showingChange = false
    @State private var oldPassword   = ""
    @State private var newPassword   = ""
    @State private var confirmNew    = ""
    @State private var showError     = false
    @State private var errorMessage  = ""

    var body: some View {
        VStack(spacing: 32) {
            // MARK: Profile Header
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 100, height: 100)
                    Text(initials(for: vm.currentUser))
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }

                Text(fullName(for: vm.currentUser))
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(vm.currentUser?.email ?? "")
                    .foregroundColor(.secondary)

                Text("@\(vm.currentUser?.username ?? "")")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
            )

            Spacer()

            // MARK: Change Password Button
            Button(action: { showingChange = true }) {
                Label("Change Password", systemImage: "lock.rotation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            // MARK: Logout Button
            Button(action: vm.logout) {
                Label("Log Out", systemImage: "arrow.backward.circle")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingChange) {
            changePasswordSheet
        }
        .alert(errorMessage, isPresented: $showError) {
            Button("OK", role: .cancel) { }
        }
        .background(Color(.secondarySystemGroupedBackground).ignoresSafeArea())
    }

    // MARK: – Change Password Sheet
    private var changePasswordSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                SecureField("Current Password", text: $oldPassword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                SecureField("Confirm New Password", text: $confirmNew)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Spacer()

                Button("Save") {
                    attemptPasswordChange()
                }
                .disabled(!canSave)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(canSave ? Color.green : Color.gray)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            }
            .padding(.top, 40)
            .navigationTitle("Change Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingChange = false
                        clearPasswordFields()
                    }
                }
            }
        }
    }

    private var canSave: Bool {
        !oldPassword.isEmpty &&
        !newPassword.isEmpty &&
        newPassword == confirmNew
    }

    private func attemptPasswordChange() {
        guard let user = vm.currentUser else { return }
        if oldPassword != user.password {
            errorMessage = "Current password is incorrect."
            showError = true
            return
        }
        vm.changePassword(to: newPassword)
        showingChange = false
        clearPasswordFields()
    }

    private func clearPasswordFields() {
        oldPassword = ""
        newPassword = ""
        confirmNew  = ""
    }

    private func fullName(for user: User?) -> String {
        "\(user?.firstName ?? "") \(user?.lastName ?? "")"
    }

    private func initials(for user: User?) -> String {
        let first = user?.firstName?.first.map(String.init) ?? ""
        let last  = user?.lastName?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx   = PersistenceController.preview.container.viewContext
        let auth  = AuthViewModel(context: ctx)
        ProfileView(vm: auth)
            .environment(\.managedObjectContext, ctx)
    }
}
