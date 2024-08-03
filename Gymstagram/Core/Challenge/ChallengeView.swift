//
//  ChallengeView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/21/24.
//
import SwiftUI

// Define a Challenge model
struct Challenge: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let description: String
    let numberOfPeople: Int
}

// Sample data
let sampleChallenges = [
    Challenge(startDate: Date(), endDate: Date().addingTimeInterval(3600), description: "Run 5 miles", numberOfPeople: 10),
    Challenge(startDate: Date(), endDate: Date().addingTimeInterval(7200), description: "Bike 20 miles", numberOfPeople: 5),
    Challenge(startDate: Date(), endDate: Date().addingTimeInterval(10800), description: "Swim 2 miles", numberOfPeople: 8)
]

struct ChallengeView: View {
    let challenges: [Challenge]

    var body: some View {
        NavigationView {
            List(challenges) { challenge in
                VStack(alignment: .leading, spacing: 10) {
                    Text(challenge.description)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text("Start Date: \(challenge.startDate, formatter: dateFormatter)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("End Date: \(challenge.endDate, formatter: dateFormatter)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Participants: \(challenge.numberOfPeople)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .navigationTitle("Challenges")
            .padding(.horizontal)
            .listStyle(InsetGroupedListStyle())
        }
    }
}

// Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// Preview
#Preview {
    ChallengeView(challenges: sampleChallenges)
}
