//
//  Post.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let timestamp: Timestamp
    let imageURL: String
    var tags: [String]
    var likes: Int
    var user: User?
    
}
