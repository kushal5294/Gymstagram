//
//  userService.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import Firebase

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else  { return }
                completion(user)
            }
    }
    
    
//    func fetchUser(withUid uid: String) async throws -> User {
//        let documentRef = Firestore.firestore().collection("users").document(uid)
//        
//        // Fetch the document snapshot using `await`
//        let snapshot = try await documentRef.getDocument()
//        
//        // Try to decode the document snapshot data as `User`
//        guard let user = try? snapshot.data(as: User.self) else {
//            throw NSError(domain: "UserFetcher", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data"])
//        }
//        
//        return user
//    }
    
    func fetchPosts() async throws -> [Post] {
        let db = Firestore.firestore()
        let query = db.collection("posts").order(by: "timestamp", descending: true)
        
        do {
            let snapshot = try await query.getDocumentsAsync()
            let posts = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
            return posts
        } catch {
            throw error
        }
    }
    
    
}
