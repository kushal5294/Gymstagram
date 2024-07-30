//
//  UserView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI

//struct ProfileView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let user = authViewModel.currentUser {
//                    Text("\(user.firstname)'s View")
//                        .padding()
//                    Text("\(user.username)")
//                    Text("\(user.credits)")
//                } else {
//                    Text("No user logged in")
//                }
//            }
//            .navigationBarItems(leading: Button(action: {
//                authViewModel.signOut()
//            }) {
//                Text("Sign Out")
//                    .foregroundColor(.blue)
//            })
//        }
//    }
//}

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var user: User? = nil
    @State private var posts: [Post]? = nil
    private var postService = PostService()
    private var friendService = FriendService()
    @State var friends: Int = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Profile Header
                    HStack {
                        // Profile Picture
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())

                        // User Info
                        VStack(alignment: .leading) {

                            HStack (spacing: 30){
                                VStack {
                                    Text(posts != nil ? "\(posts!.count)" : "0")
                                    Text(posts != nil && posts!.count == 1 ? "Post" : "Posts")
                                }
                                .font(.title3)
                                
                                VStack {
                                    Text("\(friends)")
                                    Text(friends == 1 ? "Friend" : "Friends")
                                }
                                .font(.title3)
                                
                                VStack {
                                    Text("0")
                                    Text("Bitches")
                                }
                                .font(.title3)
                                
                            }
                        }
                        .padding(.leading, 12)
                        
                        Spacer()
                    }
                    .padding()

                    // Profile Details
                    VStack(alignment: .leading, spacing: 4) {
                        Text((user != nil) ? "\(user!.firstname) \(user!.lastname)" : "Firstname Lastname")
                            .font(.headline)
                        
                        Text(user != nil ? "\(user!.caption)" : "No Caption")
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // Edit Profile Button
                    Button(action: {
                        print("Edit Profile tapped")
                    }) {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // Posts Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                        ForEach(0..<70) { index in
                            Rectangle()
                                .foregroundColor(.gray)
                                .aspectRatio(1, contentMode: .fit)
                                .padding(1)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            .navigationBarTitle((user != nil) ? "\(user!.username)" : "Username", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                            authViewModel.signOut()
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.blue)
                        })
            .navigationBarItems(trailing: Button(action: {
                print("Settings tapped")
            }) {
                Image(systemName: "gear")
                    .foregroundColor(.blue)
            })
            .onAppear {
                self.user = authViewModel.currentUser
                if let userId = self.user?.id {
                    postService.fetchUserPosts(forUid: userId) { posts in
                        self.posts = posts
                    }
                    friendService.fetchFriends(forUid: userId) { friends in
                        self.friends = friends.count
                    }
                    
                } else {
                    print("User ID is nil")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
