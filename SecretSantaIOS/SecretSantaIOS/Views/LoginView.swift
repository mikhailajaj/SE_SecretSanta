import SwiftUI
import Amplify
struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var isLogInComplete: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    Text("Login")
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
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    Button(action:{
                        Task{await login()}
                    }){
                        Text("Log In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange) // Choose a color that matches the theme
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                    HStack{
                        Text("Don't have an account? ")
                            .foregroundColor(.black)
                        NavigationLink("Sign Up", destination: SignUpView())
                            .foregroundColor(.blue)
                    }.padding(10)
                        
                        
                }
                .padding()
                .background(Color.white)
                .opacity(0.8)
                .cornerRadius(50)
            }
        }
        .navigationBarHidden(true)
    }
    func login() async {
        do {
            // 1
            let result = try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
            switch result.nextStep {
            // 2
            case .done:
                print("login is done")
            default:
                print(result.nextStep)
            }
        } catch {
            print(error)
        }
    }
}
