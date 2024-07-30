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
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.UserSession = user
            print("DEBUG: logged in with \(email)")
            self.fetchUser()
        }
        
    }
    
    func register(withEmail email: String, password: String, username: String, firstname: String, lastname: String) {
        
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
        
            Auth.auth().createUser(withEmail: email, password: password) { (result: AuthDataResult?, error: Error?) in
                if let error = error {
                    print("DEBUG: Failed to register with error \(error.localizedDescription)")
                    self.alertItem = self.getAlertItem(for: error)
                    return
                }
                guard let user = result?.user else {
                    self.alertItem = AlertContext.userSaveFailure
                    return
                }
                self.UserSession = user
                self.fetchUser()
                
                let data = [
                    "email": email,
                    "username": username.lowercased(),
                    "firstname": firstname,
                    "lastname": lastname,
                    "credits": 0,
                    "caption": "",
                ]
                
                Firestore.firestore().collection("users").document(user.uid).setData(data) { error in
                    if let error = error {
                        print("DEBUG: Failed to upload data with error \(error.localizedDescription)")
                        self.alertItem = AlertContext.userSaveFailure
                    } else {
                        print("DEBUG: Uploaded data")
                        self.alertItem = AlertContext.userSaveSuccess
                    }
                }
            }
        }
//    func register(withEmail email: String, password: String, username: String, firstname: String,
//                  lastname: String) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG: Failed to register with error \(error.localizedDescription)")
//                self.alertItem = AlertContext.invalidForm
//                return
//            }
//            guard let user = result?.user else { return }
//            self.UserSession = user
//            self.fetchUser()
//            
//            let data = ["email": email,
//                        "username": username.lowercased(),
//                        "firstname": firstname,
//                        "lastname": lastname,
//                        "credits": 0]
//            Firestore.firestore().collection("users")
//                .document(user.uid)
//                .setData(data) { _ in
//                    print("DEBUG: Uploaded data")
//                }
//        }
//        
//    }
    
    func signOut() {
        UserSession = nil
        try? Auth.auth().signOut()
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
