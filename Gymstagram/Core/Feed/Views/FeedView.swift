//
//  FeedView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
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
                }
                .navigationTitle("Feed")
            }
        }
}

#Preview {
    FeedView()
}
