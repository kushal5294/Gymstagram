//
//  postService.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import Firebase

struct PostService{
    
    func uploadPost (image: UIImage, tags: [String], completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = ["uid": uid,
                        "imageURL": imageURL,
                        "tags": tags,
                        "timestamp": Timestamp(date: Date())] as [String : Any
                        ]
            Firestore.firestore().collection("posts").document()
                .setData(data) { error in
                    if let error = error {
                        print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
        }
        
    }
    
    func fetchPosts (completion: @escaping([Post]) -> Void) {
        Firestore.firestore().collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let document = snapshot?.documents else { return }
                let posts = document.compactMap({ try? $0.data(as: Post.self)  })
                completion(posts)
            }
        
        
    }
    
    func fetchPosts (forUid uid: String, completion: @escaping([Post]) -> Void) {
        fetchFriends(forUid: uid) { friends in
            Firestore.firestore().collection("posts")
                .whereField("uid", arrayContains: friends)
                .getDocuments { snapshot, _ in
                    guard let document = snapshot?.documents else { return }
                    let posts = document.compactMap({ try? $0.data(as: Post.self)  })
                    completion(posts)
                }
            
        }
        
    }
    
    func fetchFriends(forUid uid: String, completion: @escaping([String]) -> Void) {
        let db = Firestore.firestore()
        var friends: [String] = []
        
        // Don't know how to do in 1 pass, so it is seperated for now
        db.collection("friends")
            .whereField("user1", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error)")
                    completion([])
                    return
                }
                
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let user2 = data["user2"] as? String {
                            friends.append(user2)
                        }
                    }
                }
                
                db.collection("friends")
                    .whereField("user2", isEqualTo: uid)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching friends: \(error)")
                            completion([])
                            return
                        }
                        
                        if let documents = snapshot?.documents {
                            for document in documents {
                                let data = document.data()
                                if let user1 = data["user1"] as? String {
                                    friends.append(user1)
                                }
                            }
                        }
                        
                        let filteredFriends = friends.filter { $0 != uid }
                        completion(filteredFriends)
                    }
            }
    }
}
