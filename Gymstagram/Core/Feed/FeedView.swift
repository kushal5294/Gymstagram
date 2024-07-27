//
//  FeedView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI
import Kingfisher

struct FeedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var posts: [Post] = []
    private let service = PostService()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Feed View")
                
                NavigationLink(destination: uploadPost()) {
                    Text("Upload Photo")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                List(posts) { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        Text(post.tags.joined(separator: ", "))
                    }
                }
                .onAppear {
                    service.fetchPosts { fetchedPosts in
                        posts = fetchedPosts
                    }
                }
            }
            .navigationTitle("Feed")
        }
    }
}

#Preview {
    FeedView()
}
