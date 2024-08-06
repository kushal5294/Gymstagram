//
//  Comment.swift
//  Gymstagram
//
//  Created by Adam Chouman on 8/6/24.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    var postId: String
    var userId: String
    var username: String
    var commentText: String
    var timestamp: Timestamp
}
