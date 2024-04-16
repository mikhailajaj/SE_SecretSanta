//
//  AddEventView.swift
//  SecretSanta
//
//  Created by Mohamed Fahmy on 2024-04-02.
//

import SwiftUI
import Amplify
struct AddEventView: View {
    var host_id : String
    @State var name : String = ""
    @State var description : String = ""
    @State var location : String = ""
    @State var numberOfParticipants : String = ""
    @State private var showConfirmation: Bool = false
    @State private var navigateToHome: Bool = false  // State to control navigation
    @State private var eventDetails: (code: String, name: String, location: String, description: String)?
    @State private var selectedDate: Date = Date()

    var currentUser : User
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background-home") // Make sure you have a "background-home" image in your assets
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    Text("Add Event")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    
                    CustomTextField(placeholder: "Name", text: $name)
                    CustomTextField(placeholder: "Number of Participants", text: $numberOfParticipants)
                    CustomTextField(placeholder: "Location", text: $location)
                    CustomTextField(placeholder: "Description", text: $description)
                    DatePicker(
                        "Event Date",
                        selection: $selectedDate,
                        in: Date()..., // Restricts past dates
                        displayedComponents: [.date, .hourAndMinute]
                    )
                        .datePickerStyle(GraphicalDatePickerStyle()) // Use the graphical style or compact, wheel, etc.
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    Button(action:{
                        Task{
                            await addEvent()
                        }
                    }){
                        Text("Submit")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(50)
                .opacity(0.9)
                .shadow(radius: 20)
                
            }
            .sheet(isPresented: $showConfirmation) {
                if let details = eventDetails {
                    EventConfirmationView(eventCode: details.code, eventName: details.name, eventLocation: details.location, eventDescription: details.description) {
                        navigateToHome = true  // Trigger navigation
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
        
    
    }
    
    func addEvent() async {
        do {
            let eventCode = generateRandomCode()
            let newEvent = Event(
                id: UUID().uuidString,
                name: self.name,
                participants_num: Int(self.numberOfParticipants),
                participants_joined_num : 1,
                code: eventCode,
                date: Temporal.DateTime(selectedDate), location: self.location,
                description: self.description,
                hostID: self.host_id
            )
            
            let savedEvent = try await Amplify.DataStore.save(newEvent)
            
            let userEvent = UserEvent(eventID: newEvent.id, participantID: self.host_id)
            
            let savedUserEvent = try await Amplify.DataStore.save(userEvent)
            
            print("Saved Event: \(savedEvent)")
            print("Saved UserEvent: \(savedUserEvent)")
            print("Event code: \(eventCode)")
        } catch {
            print("Couldn't add Event: \(error)")
        }
    }

    func generateRandomCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var randomCode = ""
        for _ in 0..<6 {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomCode.append(character)
        }
        return randomCode
    }

}
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
    }
}


//#Preview {
//    AddEventView(host_id: "02139218312")
//}

