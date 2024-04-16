//
//  HomeView.swift
//  SecretSanta
//
//  Created by Mohamed Fahmy on 2024-03-27.
//

import SwiftUI
import Amplify
import Combine
struct HomeView: View {
    @State var tokens : Set<AnyCancellable> = []
    @State var userEvents : [Event] = []
    @State var showEventPage : Bool = false
    @State var showProfilePage : Bool = false
    @State var showJoinEventPage : Bool = false
    @State var currentUser : User? = nil
    @EnvironmentObject var userState : UserState
    @State var username : String = ""
    var body: some View {
        NavigationStack{
            ZStack{
                Image("background-home")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Image(systemName: "person.circle")
                            .font(.system(size: 30))
                            .padding(.bottom)
                            .foregroundColor(.orange)
                            .onTapGesture {
                                showProfilePage = true
                            }
                        Spacer()
                        HStack{
                            Spacer()
                            Text(userState.username)
                            Spacer()
                        }
                        .font(.largeTitle)
                        
                    }
                    HStack{
                        Button(action:{
                            showJoinEventPage = true
                        }){
                            Text("Join Event")
                        }
                        Spacer()
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30))
                            .padding(.bottom)
                            .onTapGesture {
                                showEventPage = true
                            }
                    }
                    .foregroundColor(.orange)
                    ScrollView{
                        VStack{
                            ForEach(self.userEvents) { event in
                                EventCardView(event: event)
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $showJoinEventPage){
                    if let currentUser = currentUser {
                        JoinEventView(currentUser: currentUser)
                    } else {
                        // Handle the case where currentUser is nil
                        // You may want to show an error message or take other actions
                    }
                }
                .navigationDestination(isPresented: $showProfilePage){
                    ProfileView(userId: userState.userId)
                }
                .navigationDestination(isPresented: $showEventPage){
                    if let currentUser = currentUser {
                        AddEventView(host_id: userState.userId, currentUser: currentUser)
                    } else {
                        // Handle the case where currentUser is nil
                        // You may want to show an error message or take other actions
                    }
                    
                }
            }.onAppear(perform: {
                print("user id: \(userState.userId)")
                Task{
                    await fetchUserDetails()
                }
                observeCurrentUsersEvents()
            })
        }
    }
    func observeCurrentUsersEvents(){
        Amplify.Publisher.create(Amplify.DataStore
            .observeQuery(
                for: UserEvent.self,
                where: UserEvent.keys.participantID == userState.userId
            ))
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {print($0)}, receiveValue: {events in
            print("Events count:", events.count)
            Task{
                for event in events {
                    do {
                        let fetchedEvent = try await Amplify
                            .DataStore
                            .query(Event.self, byId: event.eventID)
                        if let ev = fetchedEvent {
                            if !self.userEvents.contains(where: {$0.id == ev.id}){
                                print("Added event: \(ev.name ?? "N/A")")
                                self.userEvents.append(ev)
                            }
                            if let index = self.userEvents.firstIndex(where: {$0.id == ev.id && $0.participants_joined_num != ev.participants_joined_num}){
                                self.userEvents[index] = ev
                            }
                        }else{
                            print("couldn't find event with this id: \(event.eventID)")
                        }
                        
                    }catch{
                        print("couldn't add events: \(error)")
                    }
                }
            }
        })
        .store(in: &tokens)
    }
    func fetchUserDetails() async{
        print("Fetching user info: ")
        do {
            let fetchedUser = try await Amplify
                .DataStore
                .query(
                    User.self,
                    byId: userState.userId
                )
            if let user = fetchedUser {
                username = user.username
                self.currentUser = user
                print("username: \(user.username)")
            }
        } catch {
            print("Couldn't fetch user: ", error)
        }
        
    }
}

//#Preview {
//    HomeView()
//}
//for event in events {
//    if !self.userEvents.contains(where: {$0.id == event.eventID}){
//        do {
//            let fetchedEvent = try await Amplify
//                .DataStore
//                .query(Event.self, byId: event.eventID)
//            if let ev = fetchedEvent {
//                self.userEvents.append(ev)
//            }else{
//                print("couldn't find event with this id: \(event.eventID)")
//            }
//            
//        }catch{
//            print("couldn't add events: \(error)")
//        }
//    }
//}
