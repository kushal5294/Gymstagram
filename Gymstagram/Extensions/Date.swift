//
//  Date.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import SwiftUI
import Firebase

extension Date {
    func timeSince() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year) year\(year > 1 ? "s" : "") ago"
        }
        if let month = components.month, month > 0 {
            return "\(month) month\(month > 1 ? "s" : "") ago"
        }
        if let day = components.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        }
        if let second = components.second, second > 0 {
            return "\(second) second\(second > 1 ? "s" : "") ago"
        }
        return "Just now"
    }
}
