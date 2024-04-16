
import SwiftUI
import Amplify

struct ProfileView: View {
    @State var username: String = ""
    @State var prefrences: [String?] = [] // Changed to non-optional [String]
    var userId: String
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        NavigationStack {
            ZStack {
                Image("background-home")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 100)) // Increased the size for better visibility
                        .padding(.bottom)
                    Text("Username: \(username)")
                        .font(.title2)
                        .padding()
                    Text("Preferences: ")
                        .font(.headline)
                        .padding(.top)
                    // Display preferences in a list or wrap in ScrollView if they don't fit on screen
                    ForEach(prefrences, id: \.self) { pref in
                        Text(pref ?? "")
                            .padding(.vertical, 4)
                    }
                    Spacer()
                    Button(action: {
                        Task {
                            await signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .background(Color.white)
                .opacity(0.8)
                .cornerRadius(50)
                .padding()
            }
        }
        .navigationTitle("Profile") // Added navigation title for better UX
        .navigationBarTitleDisplayMode(.inline) // Makes the title inline with navigation bar
        .onAppear(perform: {
            Task {
                await fetchUserDetails()
            }
        })
    }
    func signOut() async {
        do {
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            _ = try await Amplify.DataStore.clear() // clears local data from datastore
        }catch {
            print(error)
        }
    }
    func fetchUserDetails() async{
        print("Fetching user info: ")
        do {
            let fetchedUser = try await Amplify
                .DataStore
                .query(
                    User.self,
                    byId: userId
                )
            if let user = fetchedUser {
                username = user.username
                print("username: \(user.username)")
                if user.prefrences?.count ?? 0 > 0{
                    prefrences = user.prefrences!
                }else {
                    print("error happened")
                }
                
            }
        } catch {
            print("Couldn't fetch user: ", error)
        }
        
    }
}

//#Preview {
//    ProfileView()
//}
