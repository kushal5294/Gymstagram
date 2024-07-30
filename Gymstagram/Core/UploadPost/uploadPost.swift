//
//  uploadPost.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import SwiftUI

struct uploadPost: View {
    @State private var tags: [String] = [""]
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    private let service = PostService()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                showImagePicker = true
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.white)
                    Text("Select Image")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }

            Text("Tags")
                .font(.headline)

            ForEach(tags.indices, id: \.self) { index in
                TextField("Tag \(index + 1)", text: $tags[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button(action: {
                tags.append("")
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    Text("Add Tag")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }

            Button(action: {
                if let image = selectedImage {
                    service.uploadPost(image: image, tags: tags) { success in
                        if success {
                            print("Post uploaded")
                            return
                        }
                        print("Post upload failed")
                    }
                } else {
                    print("No image selected")
                }
            })
            
//            Button(action: {
//                Task {
//                    if let image = selectedImage {
//                        do {
//                            let success = try await service.uploadPost(image: image, tags: tags)
//                            if success {
//                                print("Post uploaded")
//                            } else {
//                                print("Post upload failed")
//                            }
//                        } catch {
//                            print("Post upload failed with error: \(error.localizedDescription)")
//                        }
//                    } else {
//                        print("No image selected")
//                    }
//                }
//            }) 
            {
                Text("Create Post")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Create Post")
    }
}



#Preview {
    uploadPost()
}
