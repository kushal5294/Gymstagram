//
//  commentService.swift
//  Gymstagram
//
//  Created by Adam Chouman on 8/6/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class CommentService {
    private let db = Firestore.firestore()
    
    func addComment(postId: String, comment: Comment) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                _ = try db.collection("comments").addDocument(from: comment as Comment) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func fetchComments(for postId: String) async throws -> [Comment] {
        print("Fetching comments for postId: \(postId)")
        let snapshot = try await db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .order(by: "timestamp", descending: false)
            .getDocuments()
        
        print("Fetched \(snapshot.documents.count) comments")
        let comments = snapshot.documents.compactMap { try? $0.data(as: Comment.self) }
        print("Parsed \(comments.count) comments")
        return comments
    }
    
    func listenToComments(for postId: String) -> AsyncStream<[Comment]> {
        AsyncStream { continuation in
            let listener = db.collection("comments")
                .whereField("postId", isEqualTo: postId)
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        continuation.finish()
                        print("Error listening to comments: \(error.localizedDescription)")
                    } else if let snapshot = snapshot {
                        let comments = snapshot.documents.compactMap { try? $0.data(as: Comment.self) }
                        continuation.yield(comments)
                    }
                }
            
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    func deleteComment(commentId: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.collection("comments").document(commentId).delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}



