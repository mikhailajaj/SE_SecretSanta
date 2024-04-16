//
//  SecretSantaIOSApp.swift
//  SecretSantaIOS
//
//  Created by Mohamed Fahmy on 2024-04-06.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAPIPlugin
@main
struct SecretSantaIOSApp: App {
    var body: some Scene {
        WindowGroup {
            SessionView()
        }
    }
    init() {
        configureAmplify()
    }
    func configureAmplify() {
        do {
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Failed to initialize Amplify", error)
        }
    }
}
