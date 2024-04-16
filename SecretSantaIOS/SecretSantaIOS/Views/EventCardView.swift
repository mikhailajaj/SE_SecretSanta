//
//  EventCardView.swift
//  SecretSantaIOS
//
//  Created by Mikha2il 3ajaj on 2024-04-12.
//

import SwiftUI
import Amplify

struct EventCardView: View {
    let event: Event
    @EnvironmentObject var userState : UserState
    
    var sendDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: event.createdAt?.foundationDate ?? .now)
        }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Note: You Have Been Invited To")
                    .font(.caption)
                    .foregroundColor(.black)
                Text("Event name: \(event.name ?? "N/A")")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Number of Participants: \(event.participants_joined_num ?? 0)")
                    .foregroundColor(.black)
                if userState.userId == event.hostID {
                    Text("EventCode: \(event.code ?? "N/A")")
                        .foregroundColor(.black)
                }
                Text("Event date: \(event.date?.formatDate() ?? "N/A")")
                    .foregroundColor(.black)
                Text("Location: \(event.location ?? "N/A")")
                    .foregroundColor(.black)
            }
            Spacer()
            VStack {
                // Check if the current user is the host or a guest
                if (event.participants_num == event.participants_joined_num ){
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }// if it is not full
                else{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

extension Temporal.DateTime {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self.toFoundationDate())
    }
    
    // Convert Temporal.DateTime to Date
    func toFoundationDate() -> Date {
        // Assuming iso8601String is your correctly formatted date string
        // You'll need to implement the correct conversion based on your API and string format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self.iso8601String) ?? Date()
    }
}
