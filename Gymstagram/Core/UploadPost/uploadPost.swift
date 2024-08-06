//
//  uploadPost.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import SwiftUI


//struct uploadPost: View {
//    @State private var caption: String = ""
//    @State private var tags: [String] = [""]
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//    @State private var showAlert: AlertItem?
//    @State private var navigationPath = NavigationPath()
//    
//    private let service = PostService()
//
//    var body: some View {
//        NavigationStack(path: $navigationPath) {
//            VStack(alignment: .leading, spacing: 20) {
//                Button(action: {
//                    showImagePicker = true
//                }) {
//                    HStack {
//                        Image(systemName: "photo.on.rectangle")
//                            .foregroundColor(.white)
//                        Text("Select Image")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//                .sheet(isPresented: $showImagePicker) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }
//
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                        .cornerRadius(10)
//                }
//                
//                TextField("Caption", text: $caption)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Text("Tags")
//                    .font(.headline)
//
//                ForEach(tags.indices, id: \.self) { index in
//                    TextField("Tag \(index + 1)", text: $tags[index])
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//
//                Button(action: {
//                    tags.append("")
//                }) {
//                    HStack {
//                        Image(systemName: "plus")
//                            .foregroundColor(.white)
//                        Text("Add Tag")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//
//                Button(action: {
//                    Task {
//                        if let image = selectedImage {
//                            do {
//                                let success = try await service.uploadPost(image: image, tags: tags, caption: caption)
//                                if success {
//                                    print("Post uploaded")
//                                    DispatchQueue.main.async {
//                                        navigationPath = NavigationPath(["feed"])
//                                    }
//                                } else {
//                                    print("Post upload failed")
//                                }
//                            } catch {
//                                print("Post upload failed with error: \(error.localizedDescription)")
//                            }
//                        } else {
//                            print("no image selected")
//                            showAlert = AlertContext.noImageSelected
//                        }
//                    }
//                }) {
//                    Text("Create Post")
//                        // Your existing button styling
//                }
//            }
//            .padding()
//            .navigationTitle("Create Post")
//            .navigationDestination(for: String.self) { route in
//                if route == "feed" {
//                    FeedView()
//                }
//            }
//            .alert(item: $showAlert) { alertItem in
//                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
//            }
//        }
//    }
//}


struct uploadPost: View {
    @State private var caption: String = ""
    @State private var tags: [String] = [""]
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert: AlertItem?
    @State private var navigateToFeed = false
    @Environment(\.presentationMode) var presentationMode
    
    private let service = PostService()

    var body: some View {
        NavigationStack {
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
                
                TextField("Caption", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

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
                    Task {
                        if let image = selectedImage {
                            do {
                                let success = try await service.uploadPost(image: image, tags: tags, caption: caption)
                                if success {
                                    print("Post uploaded")
                                    DispatchQueue.main.async {
                                        presentationMode.wrappedValue.dismiss()  // Go back after successful upload
                                    }
                                } else {
                                    print("Post upload failed")
                                }
                            } catch {
                                print("Post upload failed with error: \(error.localizedDescription)")
                            }
                        } else {
                            print("no image selected")
                            showAlert = AlertContext.noImageSelected
                        }
                    }
                }) {
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
            .alert(item: $showAlert) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
        }
    }
}

#Preview {
    uploadPost()
}

//redirect link is a bitch and fucking up ui for some reason

//
//import SwiftUI
//
//struct uploadPost: View {
//    @State private var caption: String = ""
//    @State private var tags: [String] = [""]
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//    @State private var showAlert: AlertItem?
//    @State private var path = NavigationPath()
//    
//    private let service = PostService()
//
//    var body: some View {
//        NavigationStack(path: $path) {
//            VStack(alignment: .leading, spacing: 20) {
//                Button(action: {
//                    showImagePicker = true
//                }) {
//                    HStack {
//                        Image(systemName: "photo.on.rectangle")
//                            .foregroundColor(.white)
//                        Text("Select Image")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//                .sheet(isPresented: $showImagePicker) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }
//
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                        .cornerRadius(10)
//                }
//                
//                TextField("Caption", text: $caption)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Text("Tags")
//                    .font(.headline)
//
//                ForEach(tags.indices, id: \.self) { index in
//                    TextField("Tag \(index + 1)", text: $tags[index])
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//
//                Button(action: {
//                    tags.append("")
//                }) {
//                    HStack {
//                        Image(systemName: "plus")
//                            .foregroundColor(.white)
//                        Text("Add Tag")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                }
//                Button(action: {
//                    Task {
//                        if let image = selectedImage {
//                            do {
//                                let success = try await service.uploadPost(image: image, tags: tags, caption: caption)
//                                if success {
//                                    print("Post uploaded")
//                                    path.append("feed")
//                                } else {
//                                    print("Post upload failed")
//                                }
//                            } catch {
//                                print("Post upload failed with error: \(error.localizedDescription)")
//                            }
//                        } else {
//                            print("no image selected")
//                            showAlert = AlertContext.noImageSelected
//                        }
//                    }
//                })
//                {
//                    Text("Create Post")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//            .navigationTitle("Create Post")
//            .alert(item: $showAlert) { alertItem in
//                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
//            }
//            .navigationDestination(for: String.self) { route in
//                if route == "feed" {
//                    FeedView()
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    uploadPost()
//}
