//
//  Challenge.swift
//  Gymstagram
//
//  Created by Adam Chouman on 8/3/24.
//

import FirebaseFirestoreSwift
import Firebase

struct Challenge: Identifiable {
    @DocumentID var id: String?
    var startTime: Date
    var endTime: Date
    var challengeDescription: String
    var sender: String
    var receivers: [Receiver]
}

struct Receiver {
    var id: String
    var status: ChallengeStatus
}

enum ChallengeStatus: String {
    case pending
    case accepted
    case declined
}
