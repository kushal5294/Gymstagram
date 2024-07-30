import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
}

struct FriendView: View {
    @State private var searchText = ""
    @State private var friends = [
        Friend(name: "Alice"),
        Friend(name: "Bob"),
        Friend(name: "Charlie"),
        Friend(name: "David"),
        Friend(name: "Eve"),
        Friend(name: "Frank")
    ]
    @State private var showingAddFriend = false

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
                            //.aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40) // Set the frame size for the image
                        Text(friend.name)
                            .font(.title2) // Adjust the font size of the text
                    }
                    //.padding() // Add padding to the HStack to increase spacing
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
