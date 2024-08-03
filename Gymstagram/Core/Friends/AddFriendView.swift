//
//  AddFriendView.swift
//  Gymstagram
//
//  Created by Adam Chouman on 7/29/24.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var friendName = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add a new friend")) {
                    TextField("Friend's name", text: $friendName)
                        .autocapitalization(.none)
                }
                Section {
                    Button("Add Friend") {
                                            }
                }
            }
            .navigationTitle("Add Friend")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


#Preview {
    AddFriendView()
}
