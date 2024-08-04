//
//  Alert.swift
//  Appetizer
//
//  Created by Adam Chouman on 7/22/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct AlertContext {
    
    //MARK: - Network Alerts
    
    static let invalidURL       =   AlertItem(title: Text("Server Error"),
                                            message: Text("The data recieved from the server was invalid. Please contact support."),
                                            dismissButton: .default(Text("OK")))
    
    static let invalidResponse  =   AlertItem(title: Text("Server Error"),
                                            message: Text("Invalid response from the server. Please try again later or contact support."),
                                            dismissButton: .default(Text("OK")))
    
    static let invalidData      =   AlertItem(title: Text("Server Error"),
                                            message: Text("There was an issue connecting to the server. If this persists contact support."),
                                            dismissButton: .default(Text("OK")))
    
    static let unableToComplete =   AlertItem(title: Text("Server Error"),
                                            message:Text("Unable to complete your request at this time. Please check your internet connection."),
                                            dismissButton: .default(Text("OK")))
    
    //MARK: - Account Alerts
    
    static let invalidForm =        AlertItem(title: Text("Invalid Form"),
                                            message:Text("Please ensure all fields in the form have been filled out"),
                                            dismissButton: .default(Text("OK")))
    
    static let weakPass =           AlertItem(title: Text("Your password is weak."),
                                            message:Text("Password must be 6 characters or more"),
                                            dismissButton: .default(Text("OK")))
    
    static let userNameBlank =      AlertItem(title: Text("Invalid Username"),
                                         message: Text("Username cannot be blank."),
                                         dismissButton: .default(Text("OK")))
    
    static let firstNameBlank =     AlertItem(title: Text("Invalid First Name"),
                                          message: Text("First name cannot be blank."),
                                          dismissButton: .default(Text("OK")))
    
    static let lastNameBlank =      AlertItem(title: Text("Invalid Last Name"),
                                         message: Text("Last name cannot be blank."),
                                         dismissButton: .default(Text("OK")))
    
    static let invalidEmail =       AlertItem(title: Text("Invalid Email"),
                                            message:Text("Please ensure your email is correct"),
                                            dismissButton: .default(Text("OK")))
    
    static let userSaveSuccess =    AlertItem(title: Text("Profile Saved"),
                                            message:Text("Your profile information was saved"),
                                            dismissButton: .default(Text("OK")))
    
    static let userSaveFailure =    AlertItem(title: Text("Profile Error"),
                                            message:Text("There was an error saving or retrieving your profile"),
                                            dismissButton: .default(Text("OK")))
    
    
    //MARK: - Account Alerts
    
    static let noImageSelected =    AlertItem(title: Text("Choose an image you fucking idiot"),
                                            message:Text("Nice one dumbass"),
                                            dismissButton: .default(Text("I'll be better next time")))
}

