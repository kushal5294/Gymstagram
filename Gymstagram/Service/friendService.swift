//
//  friendService.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/30/24.
//

import Firebase

struct FriendService {
    
//    func sendFriendRequest(user1: String, user2: String, completion: @escaping(Bool) -> Void) {
//            let db = Firestore.firestore()
//            let data = ["sender": user1,
//                        "recipient": user2,
//                        "timestamp": Timestamp(date: Date())] as [String : Any]
//            
//            db.collection("friend_requests").addDocument(data: data) { error in
//                if let error = error {
//                    print("Error sending friend request: \(error.localizedDescription)")
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        }
    
    func sendFriendRequest(user1: String, user2: String) async throws -> Bool {
        let db = Firestore.firestore()
        let data = ["sender": user1,
                    "recipient": user2,
                    "timestamp": Timestamp(date: Date())] as [String : Any]

        return try await withCheckedThrowingContinuation { continuation in
            db.collection("friend_requests").addDocument(data: data) { error in
                if let error = error {
                    print("Error sending friend request: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
        
    func acceptFriendRequest(user1: String, user2: String, completion: @escaping(Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("friend_requests")
            .whereField("sender", isEqualTo: user1)
            .whereField("recipient", isEqualTo: user2)
            .getDocuments { snapshot1, error1 in
                if let error1 = error1 {
                    print("Error checking friend request: \(error1.localizedDescription)")
                    completion(false)
                    return
                }
                
        db.collection("friend_requests")
            .whereField("sender", isEqualTo: user2)
            .whereField("recipient", isEqualTo: user1)
            .getDocuments { snapshot2, error2 in
                if let error2 = error2 {
                    print("Error checking friend request: \(error2.localizedDescription)")
                    completion(false)
                    return
                }
                        
                let allSnapshots = [snapshot1, snapshot2].compactMap { $0 }
                let requests = allSnapshots.flatMap { $0.documents }
                
                guard let document = requests.first else {
                    print("No friend request found")
                    completion(false)
                    return
                }
                
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting friend request: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    let friendData = ["user1": user1,
                                      "user2": user2,
                                      "timestamp": Timestamp(date: Date())] as [String : Any]
                    
                    db.collection("friends").addDocument(data: friendData) { error in
                        if let error = error {
                            print("Error adding friend: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    func removeFriends(user1: String, user2: String, completion: @escaping(Bool) -> Void) {
        let db = Firestore.firestore()
        
        let friendsQuery = db.collection("friends")
            .whereField("user1", isEqualTo: user1)
            .whereField("user2", isEqualTo: user2)
        
        friendsQuery.getDocuments { (snapshot1, error1) in
            if let error1 = error1 {
                print("Error finding friends: \(error1.localizedDescription)")
                completion(false)
                return
            }
            
            let reverseFriendsQuery = db.collection("friends")
                .whereField("user1", isEqualTo: user2)
                .whereField("user2", isEqualTo: user1)
            
            reverseFriendsQuery.getDocuments { (snapshot2, error2) in
                if let error2 = error2 {
                    print("Error finding reverse friends: \(error2.localizedDescription)")
                    completion(false)
                    return
                }
                
                let allSnapshots = [snapshot1, snapshot2].compactMap { $0 }
                let friends = allSnapshots.flatMap { $0.documents }
                
                guard let document = friends.first else {
                    print("No friends document found")
                    completion(false)
                    return
                }
                
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing friends: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
//    func removeFriends(user1: String, user2: String) async -> Bool {
//        let db = Firestore.firestore()
//        
//        let friendsQuery = db.collection("friends")
//            .whereField("user1", isEqualTo: user1)
//            .whereField("user2", isEqualTo: user2)
//        
//        let reverseFriendsQuery = db.collection("friends")
//            .whereField("user1", isEqualTo: user2)
//            .whereField("user2", isEqualTo: user1)
//        
//        do {
//            let snapshot1 = try await friendsQuery.getDocumentsAsync()
//            let snapshot2 = try await reverseFriendsQuery.getDocumentsAsync()
//            
//            let allSnapshots = [snapshot1, snapshot2]
//            let friends = allSnapshots.flatMap { $0.documents }
//            
//            guard let document = friends.first else {
//                print("No friends document found")
//                return false
//            }
//            
//            try await document.reference.deleteAsync()
//            return true
//        } catch {
//            print("Error removing friends: \(error.localizedDescription)")
//            return false
//        }
//    }

    
    func fetchFriends(forUid uid: String, completion: @escaping([String]) -> Void) {
        let db = Firestore.firestore()
        var friends: [String] = []
        
        // Idk how to do in 1 pass, so it is seperated
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




