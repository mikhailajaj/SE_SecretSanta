//
//  JoinEventView.swift
//  SecretSantaIOS
//
//  Created by Mohamed Fahmy on 2024-04-10.
//

import SwiftUI
import Amplify
struct JoinEventView: View {
    @State var eventCode : String = ""
    var currentUser : User
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background-home") // Make sure you have a "background-home" image in your assets
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Join Event")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    
                    TextField("Event Code",
                              text: $eventCode)
                        .padding()
                       .background(Color.white.opacity(0.8))
                       .cornerRadius(10)
                       .shadow(radius: 5)
                       .padding(.horizontal)
                       .textContentType(.oneTimeCode)
                    
                    Button(action:{
                        Task{
                            await joinEvent()
                        }
                    }){
                        Text("Join")
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
        }
    }
    func joinEvent() async{
        do{
            var fetchedEvent = try await Amplify
                .DataStore
                .query(Event.self,where: Event.keys.code == self.eventCode).first
            if fetchedEvent != nil && fetchedEvent?.participants_joined_num != fetchedEvent?.participants_num {
                // checks that there's space for one more to join
                let fetchedUserEvents = try await Amplify
                    .DataStore
                    .query(UserEvent.self, where: UserEvent.keys.eventID == fetchedEvent?.id && UserEvent.keys.participantID == currentUser.id)
                if fetchedUserEvents.isEmpty{
                    let userEvent = UserEvent(eventID: fetchedEvent!.id, participantID: currentUser.id)
                    let savedUserEvent = try await Amplify.DataStore.save(userEvent)
                    fetchedEvent?.participants_joined_num! += 1
                    let mutatedEvent = try await Amplify.DataStore.save(fetchedEvent!)
                    print("Created User Event: \(savedUserEvent)")
                    print("User has joined the event")
                }else {
                    print("User is already in th event")
                    // user is already registered in event
                }
                if let event = fetchedEvent{
                    print("Fetched Event: \(event)")
                }
            }
            
        }catch{
            print("Couldn't fetch event")
        }
    }
}

//#Preview {
//    JoinEventView()
//}

//#Preview {
//    JoinEventView()
//}


