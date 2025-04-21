//
//  AuthViewModel.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.


import Foundation
import CoreData

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: – Input fields
    @Published var firstName        = ""
    @Published var lastName         = ""
    @Published var username         = ""
    @Published var email            = ""
    @Published var password         = ""
    @Published var confirmPassword  = ""

    @Published var isLoggedIn = false
    @Published var currentUser: User?

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context    = context
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

        if isLoggedIn {
            // load the saved user (here we just grab the first one)
            let req: NSFetchRequest<User> = User.fetchRequest()
            req.fetchLimit = 1
            if let user = (try? context.fetch(req))?.first {
                currentUser = user
            }
        }
    }

    // MARK: – Login
    func login() {
        let req: NSFetchRequest<User> = User.fetchRequest()
        req.predicate = NSPredicate(
          format: "((email   ==[c] %@) OR (username ==[c] %@)) AND password == %@",
          email, email, password
        )

        do {
            let matches = try context.fetch(req)
            if let user = matches.first {
                didAuthenticate(user)
            } else {
                print("❌ invalid credentials")
            }
        } catch {
            print("❌ login fetch failed:", error)
        }
    }

    // MARK: – Register
    func register() {
        // basic validation
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password == confirmPassword else {
          print("❌ validation failed")
          return
        }

        // ensure username is unique
        let userReq: NSFetchRequest<User> = User.fetchRequest()
        userReq.predicate = NSPredicate(format: "username == %@", username)
        if let matches = try? context.fetch(userReq), !matches.isEmpty {
          print("❌ username taken")
          return
        }

        let newUser = User(context: context)
        newUser.id         = UUID()
        newUser.firstName  = firstName
        newUser.lastName   = lastName
        newUser.username   = username
        newUser.email      = email
        newUser.password   = password  // ⚠️ hash in prod!

        do {
          try context.save()
          didAuthenticate(newUser)
        } catch {
          print("❌ could not save new user:", error)
        }
    }

    // MARK: – Change Password
    func changePassword(to newPassword: String) {
        guard let user = currentUser else { return }
        user.password = newPassword
        try? context.save()
    }

    // MARK: – Logout & Reset
    func logout() {
        // Clear persisted login state
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn  = false
        currentUser = nil

        // Clear all input fields
        firstName       = ""
        lastName        = ""
        username        = ""
        email           = ""
        password        = ""
        confirmPassword = ""
    }

    // MARK: – Helpers
    private func didAuthenticate(_ user: User) {
        currentUser = user
        isLoggedIn  = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
}
