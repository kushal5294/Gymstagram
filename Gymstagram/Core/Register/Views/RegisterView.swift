//
//  RegisterView.swift
//  crypto
//
//  Created by Kushal Patel on 7/21/24.
//
import SwiftUI

struct RegisterView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var showMainView: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Username", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                

                Button(action: {
                    viewModel.register(withEmail: email, password: password, username: userName, firstname: firstName, lastname: lastName)
                }) {
                    Text("Register")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }

            }
            .padding()
        }
    }
}

