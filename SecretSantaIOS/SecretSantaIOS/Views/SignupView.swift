import SwiftUI
import Amplify
struct SignUpView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var userID : String?
    @State var shouldShowConfirmSignUp: Bool = false
    @State var preferences: [String] = []
    let preferencesOptions: [String] = [
            "Toys",
            "Decorations",
            "Electronics",
            "Clothes"
        ]
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Sign Up")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
               
                VStack {
                    ForEach(preferencesOptions, id: \.self) { preference in
                        PreferenceSelectionView(preference: preference, selectedPreferences: $preferences)
                    }
                }
                Spacer()
                Button("Sign Up", action: {
                    Task { await signUp() }
                })
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()

                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(50)
            .opacity(0.9)
            .shadow(radius: 20)
            // 3
            .navigationDestination(isPresented: .constant(shouldShowConfirmSignUp)) {
                var userPackage : UserPackage = .init(
                    id: userID, username: username,
                    prefrences: preferences
                )
                ConfirmSignUpView(userpackage: userPackage)
            }
        }
    }
    func signUp() async {
        // 1
        let options = AuthSignUpRequest.Options(
            userAttributes: [.init(.email, value: email)]
        )
        do {
            // 2
            let result = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            
            switch result.nextStep {
            // 3
            case .confirmUser:
                DispatchQueue.main.async {
                    self.shouldShowConfirmSignUp = true
                    userID = result.userID
                }
            default:
                print(result)
            }
        } catch {
            print(error)
        }
    }
}
struct PreferenceSelectionView: View {
    var preference: String
    @Binding var selectedPreferences: [String]
    
    var isSelected: Bool {
        selectedPreferences.contains(preference)
    }
    
    var body: some View {
        Text(preference)
            .foregroundColor(isSelected ? .green : .black)
            .padding()
            .background(isSelected ? Color.white.opacity(0.8) : Color.clear)
            .cornerRadius(10)
            .shadow(radius: isSelected ? 5 : 0)
            .onTapGesture {
                if isSelected {
                    selectedPreferences.removeAll { $0 == preference }
                } else {
                    selectedPreferences.append(preference)
                }
            }
    }
}
