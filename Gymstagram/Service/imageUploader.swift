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
    
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            throw NSError(domain: "ImageUploader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/post_image/\(filename)")
        
        do {
            let _ = try await ref.putDataAsync(imageData)
        } catch {
            print("DEBUG: Failed to upload image data. Error: \(error)")
            throw NSError(domain: "ImageUploader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image data: \(error.localizedDescription)"])
        }
        
        do {
            let imageURL = try await ref.downloadURL()
            return imageURL.absoluteString
        } catch {
            print("DEBUG: Failed to get download URL. Error: \(error)")
            throw NSError(domain: "ImageUploader", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL: \(error.localizedDescription)"])
        }
    }
}



