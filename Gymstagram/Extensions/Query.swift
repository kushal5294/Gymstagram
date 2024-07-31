//
//  Query.swift
//  Gymstagram
//
//  Created by Adam Chouman on 7/31/24.
//

import SwiftUI
import Firebase

extension Query {
    func getDocumentsAsync() async throws -> QuerySnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            self.getDocuments { (snapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let snapshot = snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
                }
            }
        }
    }
}
