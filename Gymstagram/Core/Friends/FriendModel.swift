//
//  FriendModel.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/30/24.
//

import Foundation
import FirebaseFirestoreSwift
import Combine

class FriendModel: ObservableObject {
    @Published var friends: [User] = []
    
    init() {
        self.friends = []
    }
    
    
    func setFriends(ids: [String]) {
        self.friends.removeAll()
        fetchFriends(friendIDs: ids)
    }
    
    private func fetchFriends(friendIDs: [String]) {
        let userService = UserService()
        let dispatchGroup = DispatchGroup()
        
        for friendID in friendIDs {
            dispatchGroup.enter()
            userService.fetchUser(withUid: friendID) { [weak self] friend in
                DispatchQueue.main.async {
                    self?.friends.append(friend)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All friends have been fetched.")
        }
    }
}
