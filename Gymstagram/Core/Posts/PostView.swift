//
//  PostView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    var post: Post
    @State private var isLiked: Bool = false
    @State private var postOwner: User? = nil
    @EnvironmentObject var viewModel: AuthViewModel
    private let userService = UserService()
    private let postService = PostService()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                // lzy loading; more optimal
                if let owner = postOwner {
                                    HStack {
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 23))

                                        Text(owner.username)
                                    }

                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                } else {
                                    // loading state
                                    HStack {
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 23))

                                        Text("Loading...")
                                    }

                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                }
                
                
                
                Spacer()
                Text("\(post.timestamp.dateValue().timeSince())" )
                    .padding(.trailing, 10)

            }
            KFImage(URL(string: post.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .clipped()
                
            
            HStack{
                Button(action: {
                    self.isLiked.toggle()
                    Task {
                        if let usr = viewModel.currentUser {
                            await postService.handleLike(likerUid: usr.id!, postID: post.id!)
                        }
                    }
                    
                }, label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 34))
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                })
                
                
                TagView(tags: post.tags)
            }
            
            .padding(.top,8)
            
            
        }
        .padding(.vertical, 8)
        .onAppear {
            userService.fetchUser(withUid: post.uid) { user in
                postOwner = user
            }
            Task {
                if let usr = viewModel.currentUser {
                    let liked = await postService.isLiked(likerUid: usr.id!, postID: post.id!)
                    self.isLiked = liked
                }
            }
        }
    }
        
}
