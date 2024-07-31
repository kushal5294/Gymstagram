//
//  AuthViewModel.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var UserSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var alertItem: AlertItem?
    private let service = UserService()

    init() {
        self.UserSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }

    func login(withEmail email: String, password: String) {
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.UserSession = result.user
                print("DEBUG: logged in with \(email)")
                await fetchUser()
            } catch {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
            }
        }
    }

    func register(withEmail email: String, password: String, username: String, firstname: String, lastname: String) {
        Task {
            guard !username.isEmpty else {
                self.alertItem = AlertContext.userNameBlank
                return
            }
            guard !firstname.isEmpty else {
                self.alertItem = AlertContext.firstNameBlank
                return
            }
            guard !lastname.isEmpty else {
                self.alertItem = AlertContext.lastNameBlank
                return
            }

            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                let user = result.user
                self.UserSession = user
                await fetchUser()

                let data = [
                    "email": email,
                    "username": username.lowercased(),
                    "firstname": firstname,
                    "lastname": lastname,
                    "credits": 0,
                    "caption": "",
                ]
                
                try await Firestore.firestore().collection("users").document(user.uid).setData(data)
                print("DEBUG: Uploaded data")
                self.alertItem = AlertContext.userSaveSuccess
            } catch {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                self.alertItem = self.getAlertItem(for: error)
            }
        }
    }

    func signOut() {
        Task {
            do {
                try Auth.auth().signOut()
                self.UserSession = nil
            } catch {
                print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
            }
        }
    }

    private func getAlertItem(for error: Error) -> AlertItem {
        // Customize the alert messages based on the error code or description
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return AlertContext.invalidEmail
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return AlertItem(title: Text("Email In Use"), message: Text("The email address is already in use by another account."), dismissButton: .default(Text("OK")))
        case AuthErrorCode.weakPassword.rawValue:
            return AlertContext.weakPass
        default:
            print("\(error.localizedDescription)")
            return AlertContext.invalidForm
        }
    }

    func fetchUser (){
        guard let uid = self.UserSession?.uid else { return }
        service.fetchUser(withUid: uid) { dbUser in
            self.currentUser = dbUser
        }
        print("email is \(String(describing: currentUser?.email))")
    }
}
