//
//  imageUploader.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import Firebase
import FirebaseStorage
import UIKit

struct ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/post_image/\(filename)")
        
        ref.putData(imageData) { _ , error in
            if let error = error {
                print("DEBUG: Failed to upload with error: \(error.localizedDescription)")
                return
            }
            ref.downloadURL { imageURL, _ in
                guard let imageURL = imageURL?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
    
}

//struct ImageUploader {
//    
//    static func uploadImage(image: UIImage) async throws -> String {
//        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
//            throw NSError(domain: "ImageUploader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
//        }
//        
//        let filename = NSUUID().uuidString
//        let ref = Storage.storage().reference(withPath: "/post_image/\(filename)")
//        
//        do {
//            try await ref.putData(imageData)
//        } catch {
//            print("DEBUG: Failed to upload image data. Error: \(error)")
//            if let storageError = error as? StorageError {
//                switch storageError {
//                case .quotaExceeded:
//                    print("DEBUG: Storage quota exceeded")
//                case .unauthenticated:
//                    print("DEBUG: User is unauthenticated")
//                case .unauthorized:
//                    print("DEBUG: User is unauthorized to perform this operation")
//                case .retryLimitExceeded:
//                    print("DEBUG: Retry limit exceeded")
//                case .downloadSizeExceeded:
//                    print("DEBUG: Download size exceeded")
//                case .cancelled:
//                    print("DEBUG: Operation cancelled")
//                case .unknown:
//                    print("DEBUG: Unknown error occurred")
//                @unknown default:
//                    print("DEBUG: Unhandled error case")
//                }
//            }
//            throw error  // Re-throw the error after logging
//        }
//        
//        let imageURL = try await ref.downloadURL()
//        return imageURL.absoluteString
//    }
//    
//}
