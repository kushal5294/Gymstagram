//
//  ChallengeService.swift
//  Gymstagram
//
//  Created by Adam Chouman on 8/3/24.
//

import Firebase

struct ChallengeService {
    func sendChallenge(challenge: Challenge) async throws {
        let db = Firestore.firestore()
        let challengeData: [String: Any] = [
            "startTime": challenge.startTime,
            "endTime": challenge.endTime,
            "challengeDescription": challenge.challengeDescription,
            "sender": challenge.sender,
            "receivers": challenge.receivers.map { ["id": $0.id, "status": $0.status.rawValue] }
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("challenges").addDocument(data: challengeData) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func respondToChallenge(challengeId: String, receiverId: String, status: ChallengeStatus) async throws {
        let db = Firestore.firestore()
        let challengeRef = db.collection("challenges").document(challengeId)
        
        let document = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DocumentSnapshot, Error>) in
            challengeRef.getDocument { (snapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let snapshot = snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirestoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"]))
                }
            }
        }
        
        if var challengeData = document.data(), var receivers = challengeData["receivers"] as? [[String: Any]] {
            if let index = receivers.firstIndex(where: { $0["id"] as? String == receiverId }) {
                receivers[index]["status"] = status.rawValue
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                    challengeRef.updateData(["receivers": receivers]) { error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume()
                        }
                    }
                }
            }
        }
    }

    func fetchChallenges(for userId: String, status: ChallengeStatus) async throws -> [QueryDocumentSnapshot] {
        let db = Firestore.firestore()
        let query = db.collection("challenges").whereField("receivers", arrayContains: ["id": userId, "status": status.rawValue])
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[QueryDocumentSnapshot], Error>) in
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot.documents)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirestoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"]))
                }
            }
        }
    }
}
