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
                        ForEach(posts) { post in
                            PostView(post: post)
                        }
                    }
                }
                .onAppear {
                    service.fetchPosts { fetchedPosts in
                        posts = fetchedPosts
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FeedView()
}
