//
//  DocumentReference.swift
//  Gymstagram
//
//  Created by Adam Chouman on 7/31/24.
//

import SwiftUI
import Firebase

extension DocumentReference {
    func deleteAsync() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
