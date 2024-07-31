//
//  StorageReference.swift
//  Gymstagram
//
//  Created by Adam Chouman on 7/31/24.
//

//import SwiftUI
//import FirebaseStorage

//extension StorageReference {
//    func putDataAsync(_ uploadData: Data) async throws -> StorageMetadata {
//        return try await withCheckedThrowingContinuation { continuation in
//            self.putData(uploadData, metadata: nil) { metadata, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let metadata = metadata {
//                    continuation.resume(returning: metadata)
//                } else {
//                    continuation.resume(throwing: NSError(domain: "ImageUploader", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
//                }
//            }
//        }
//    }
//}
