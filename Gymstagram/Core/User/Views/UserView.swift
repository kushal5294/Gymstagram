//
//  UserView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    Text("\(user.firstname)'s View")
                        .padding()
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
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(AuthViewModel()) 
    }
}
