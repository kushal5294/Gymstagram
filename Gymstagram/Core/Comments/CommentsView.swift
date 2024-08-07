import SwiftUI
import Firebase

struct CommentView: View {
    var post: Post
    @State private var comments = [Comment]()
    @State private var newCommentText = ""
    @EnvironmentObject var viewModel: AuthViewModel
    private let commentService = CommentService()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.headline)
                .padding(.horizontal, 10)
            
            ForEach(comments) { comment in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 23))
                        Text(comment.username)
                        Spacer()
                        // Add a delete button if the user is the owner of the comment
                        if viewModel.currentUser?.id == comment.userId {
                            Button(action: {
                                Task {
                                    await deleteComment(commentId: comment.id ?? "")
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    Text(comment.commentText)
                        .padding(.leading, 30)
                        .padding(.top, 2)
                }
                .padding(.bottom, 8) // Optional: Add some space between comments
            }
            
            HStack {
                TextField("Add a comment...", text: $newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    if let user = viewModel.currentUser {
                        Task {
                            await addComment(userId: user.id!, username: user.username)
                        }
                    }
                }) {
                    Text("Post")
                        .bold()
                }
                .padding(.trailing)
            }
            .padding(.vertical)
        }
        .padding(.top, 8)
        .onAppear {
            Task {
                await fetchComments() // Fetch comments when view appears
            }
        }
    }
    
    // Fetch comments function
    private func fetchComments() async {
        print("Fetching comments for postId: \(post.id ?? "")")
        do {
            let fetchedComments = try await commentService.fetchComments(for: post.id ?? "")
            print("Fetched \(fetchedComments.count) comments")
            self.comments = fetchedComments
        } catch {
            print("Error fetching comments: \(error.localizedDescription)")
        }
    }
    
    // Add comment function
    private func addComment(userId: String, username: String) async {
        let newComment = Comment(
            postId: post.id ?? "",
            userId: userId,
            username: username,
            commentText: newCommentText,
            timestamp: Timestamp()
        )
        do {
            try await commentService.addComment(postId: post.id ?? "", comment: newComment)
            self.newCommentText = ""
            await fetchComments() // Refresh comments after adding a new one
        } catch {
            print("Error adding comment: \(error.localizedDescription)")
        }
    }
    
    // Delete comment function
    private func deleteComment(commentId: String) async {
        do {
            try await commentService.deleteComment(commentId: commentId)
            // delete comment locally so it updates faster
            self.comments.removeAll { $0.id == commentId }
        } catch {
            print("Error deleting comment: \(error.localizedDescription)")
        }
    }
}
