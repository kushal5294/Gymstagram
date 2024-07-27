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
