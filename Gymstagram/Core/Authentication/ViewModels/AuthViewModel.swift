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
        }
    }
    
    func register(withEmail email: String, password: String, username: String, firstname: String,
                  lastname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            self.UserSession = user
            
            let data = ["email": email,
                        "username": username.lowercased(),
                        "firstname": firstname,
                        "lastname": lastname]
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    print("DEBUG: Uploaded data")
                }
        }
    }
    
    func signOut() {
        UserSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser (){
        guard let uid = self.UserSession?.uid else { return }
        service.fetchUser(withUid: uid) { dbUser in
            self.currentUser = dbUser
        }
        print("email is \(String(describing: currentUser?.email))")
    }
    
    
    
    
}
