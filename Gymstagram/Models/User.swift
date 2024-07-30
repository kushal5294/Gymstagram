//
//  User.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    
    @DocumentID var id: String?
    let username: String
    let firstname: String
    let lastname: String
    let email: String
    let credits: Int
    let caption: String
    
}
