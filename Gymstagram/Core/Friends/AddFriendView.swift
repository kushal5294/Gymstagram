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
                }
                Section {
                    Button("Add Friend") {
                        // Add friend logic goes here
                        //presentationMode.wrappedValue.dismiss()
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
