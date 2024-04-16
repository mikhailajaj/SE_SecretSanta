//
//  EventConfirmationView.swift
//  SecretSantaIOS
//
//  Created by Mikha2il 3ajaj on 2024-04-12.
//
import SwiftUI

struct EventConfirmationView: View {
    let eventCode: String
    let eventName: String
    let eventLocation: String
    let eventDescription: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Event Created Successfully!")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                DetailRow(label: "Event Name:", value: eventName)
                DetailRow(label: "Event Code:", value: eventCode)
                DetailRow(label: "Location:", value: eventLocation)
                DetailRow(label: "Description:", value: eventDescription)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)

            Button("OK") {
                onDismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}
