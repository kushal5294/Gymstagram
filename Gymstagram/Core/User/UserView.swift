//
//  UserView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let user = authViewModel.currentUser {
                    Text("\(user.firstname)'s View")
                        .padding()
                } else {
                    Text("No user logged in")
                }
            }
            .navigationBarItems(leading: Button(action: {
                authViewModel.signOut()
            }) {
                Text("Sign Out")
                    .foregroundColor(.blue)
            })
        }
    }
}

#Preview {
    ProfileView()
}
