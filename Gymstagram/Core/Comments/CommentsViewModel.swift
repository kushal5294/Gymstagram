//
//  CommentsViewModel.swift
//  Gymstagram
//
//  Created by Adam Chouman on 8/6/24.
//
import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var newCommentText = ""
    private let commentService = CommentService()
    private var listenTask: Task<Void, Never>?
    private let postId: String
    
    init(postId: String) {
        self.postId = postId
        Task {
            await fetchComments()
            listenToComments()
        }
    }
    
    deinit {
        listenTask?.cancel()
    }
    
    func fetchComments() async {
        print("ViewModel: Fetching comments for postId: \(postId)")
        do {
            let fetchedComments = try await commentService.fetchComments(for: postId)
            print("ViewModel: Fetched \(fetchedComments.count) comments")
            self.comments = fetchedComments
            print("ViewModel: Comments array - \(self.comments)")
        } catch {
            print("Error fetching comments: \(error.localizedDescription)")
        }
    }
    
    func listenToComments() {
        listenTask = Task {
            for await newComments in commentService.listenToComments(for: postId) {
                self.comments = newComments
            }
        }
    }
    
    func addComment(userId: String, username: String) async {
        let newComment = Comment(
            postId: postId,
            userId: userId,
            username: username,
            commentText: newCommentText,
            timestamp: Timestamp()
        )
        do {
            try await commentService.addComment(postId: postId, comment: newComment)
            self.newCommentText = ""
        } catch {
            print("Error adding comment: \(error.localizedDescription)")
        }
    }
}
