//
//  GymstagramApp.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/16/24.
//

import SwiftUI
import Firebase



@main
struct GymstagramApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .environmentObject(viewModel)
    }
}
