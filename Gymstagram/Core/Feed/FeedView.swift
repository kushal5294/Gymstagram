//
//  FeedView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI
import Kingfisher

struct FeedView: View {
    @State private var posts: [Post] = []
    private let service = PostService()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Feed")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink(destination: uploadPost()) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack {
                        ForEach(posts.filter { $0.uid != viewModel.currentUser?.id }) { post in
                            PostView(post: post)
                        }
                    }
                }
                .task {
                    do {
                        let allPosts = try await service.fetchPosts()
                        posts = allPosts.filter { $0.uid != viewModel.currentUser?.id }
                    } catch {
                        print("Failed to fetch posts: \(error.localizedDescription)")
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FeedView().environmentObject(AuthViewModel())
}
