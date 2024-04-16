import SwiftUI
import Amplify
struct ConfirmSignUpView: View {
    let userpackage: UserPackage
    @State var confirmationCode: String = ""
    @State var shouldShowLogin: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    Text("Confirm Sign Up")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)

                    TextField("Verification Code", text: $confirmationCode)
                    Button("Submit", action: {
                        Task { await confirmSignUp() }
                    })
                    .foregroundColor(.white)
                   .padding()
                   .frame(maxWidth: .infinity)
                   .background(Color.orange)
                   .cornerRadius(10)
                   .shadow(radius: 10)
                   .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(50)
                .opacity(0.9)
                .shadow(radius: 20)
                .navigationBarHidden(true)
                // 2
                .navigationDestination(isPresented: .constant(shouldShowLogin)) {
                    LoginView()
                }
            }
        }
    }
    func confirmSignUp() async {
        do {
            // 1
            let result = try await Amplify.Auth.confirmSignUp(
                for: userpackage.username,
                confirmationCode: confirmationCode
            )
            switch result.nextStep {
            // 2
            case .done:
                DispatchQueue.main.async {
                    Task{
                        let newUser = User(
                            id: userpackage.id!,
                            username: userpackage.username,
                            prefrences: userpackage.prefrences
                        )
                        let savedUser = try await Amplify.DataStore.save(newUser)
                        print("Created user: \(savedUser)")
                    }
                    self.shouldShowLogin = true
                }
            default:
                print(result.nextStep)
            }
        } catch {
            print(error)
        }
    }
}
