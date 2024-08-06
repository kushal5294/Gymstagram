//
//  postService.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import Firebase

struct PostService {
    
//    func uploadPost (image: UIImage, tags: [String], completion: @escaping(Bool) -> Void){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        ImageUploader.uploadImage(image: image) { imageURL in
//            let data = ["uid": uid,
//                        "imageURL": imageURL,
//                        "tags": tags,
//                        "timestamp": Timestamp(date: Date())] as [String : Any
//                        ]
//            Firestore.firestore().collection("posts").document()
//                .setData(data) { error in
//                    if let error = error {
//                        print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//        }
//    }
    
    func uploadPost(image: UIImage, tags: [String], caption: String) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Authentication", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        do {
            let imageURL = try await ImageUploader.uploadImage(image: image)
            
            let data = [
                "uid": uid,
                "imageURL": imageURL,
                "tags": tags,
                "timestamp": Timestamp(date: Date()),
                "caption": caption,
            ] as [String : Any]
            
            try await Firestore.firestore().collection("posts").document().setData(data)
            
            return true
        } catch {
            print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
//    func fetchPosts (completion: @escaping([Post]) -> Void) {
//        Firestore.firestore().collection("posts")
//            .order(by: "timestamp", descending: true)
//            .getDocuments { snapshot, _ in
//                guard let document = snapshot?.documents else { return }
//                let posts = document.compactMap({ try? $0.data(as: Post.self)  })
//                completion(posts)
//            }
//        
//        
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
    
    func fetchPosts (forUid uid: String, completion: @escaping([Post]) -> Void) {
        FriendService().fetchFriends(forUid: uid) { friends in
            Firestore.firestore().collection("posts")
                .whereField("uid", arrayContains: friends)
                .getDocuments { snapshot, _ in
                    guard let document = snapshot?.documents else { return }
                    let posts = document.compactMap({ try? $0.data(as: Post.self)  })
                    completion(posts)
                }
            
        }
        
    }
    
    func fetchUserPosts (forUid uid: String, completion: @escaping([Post]) -> Void) {
        Firestore.firestore().collection("posts")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let document = snapshot?.documents else { return }
                let posts = document.compactMap({ try? $0.data(as: Post.self)  })
                completion(posts)
            }
    }
    
    func isLiked(likerUid: String, postID: String) async -> Bool {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("likes")
                .whereField("postID", isEqualTo: postID)
                .whereField("uid", isEqualTo: likerUid)
                .getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            print("Error checking like status: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func handleLike(likerUid: String, postID: String) async -> Void {
        let liked = await isLiked(likerUid: likerUid, postID: postID)
        let db = Firestore.firestore()
        do {
            if liked {
                let snapshot = try await db.collection("likes")
                    .whereField("postID", isEqualTo: postID)
                    .whereField("uid", isEqualTo: likerUid)
                    .getDocuments()
                if let document = snapshot.documents.first {
                    try await document.reference.delete()
                    return
                }
            } else {
                let data = ["postID": postID, "uid": likerUid, "timestamp": Timestamp(date: Date())] as [String : Any]
                try await db.collection("likes").addDocument(data: data)
                return
            }
        } catch {
            print("Error handling like: \(error.localizedDescription)")
            return
        }
    }
    func fetchLikeCount(forPostID postID: String) async -> Int {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("likes")
                .whereField("postID", isEqualTo: postID)
                .getDocuments()
            return snapshot.documents.count
        } catch {
            print("Error fetching like count: \(error.localizedDescription)")
            return 0
        }
    }

    
}
