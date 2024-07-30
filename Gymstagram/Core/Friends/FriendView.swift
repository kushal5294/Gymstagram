import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
}

struct FriendView: View {
    @State private var searchText = ""
    @StateObject var friendModel = FriendModel() // Initialize the FriendModel
    @State private var showingAddFriend = false
    @EnvironmentObject var viewModel: AuthViewModel

    var filteredFriends: [User] {
            if searchText.isEmpty {
                return friendModel.friends
            } else {
                return friendModel.friends.filter { user in
                    let fullName = "\(user.firstname) \(user.lastname)"
                    return fullName.lowercased().contains(searchText.lowercased())
                }
            }
        }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List(filteredFriends) { friend in
                    HStack (spacing: 20) {
                        Image(systemName: "person")
                            .resizable() // Make the image resizable
                            .frame(width: 40, height: 40) // Set the frame size for the image
                        Text("\(friend.firstname) \(friend.lastname)")
                            .font(.title2) // Adjust the font size of the text
                    }
                }
                .navigationTitle("Friends")
                .navigationBarItems(trailing: Button(action: {
                    showingAddFriend = true
                }) {
                    Image(systemName: "plus")
                })
                .fullScreenCover(isPresented: $showingAddFriend) {
                    AddFriendView()
                }
                .onAppear() {
                    if let userId = viewModel.currentUser?.id {
                        FriendService().fetchFriends(forUid: userId) { ids in
                            friendModel.setFriends(ids: ids)
                        }
                    } else {
                        print("User ID is nil")
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}

#Preview {
    FriendView()
}
