//
//  MainView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.UserSession == nil {
            SignInView()
            
        } else {
            TabView {
                FeedView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Feed")
                    }
                ChallengeView(challenges: sampleChallenges)
                    .tabItem {
                        Image(systemName: "dumbbell")
                        Text("Challenges")
                    }
                FriendView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                
            }
            .navigationBarBackButtonHidden()
        }
    }
}
