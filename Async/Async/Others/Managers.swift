//
//  Managers.swift
//  Async
//
//  Created by Tarun Verma on 03/01/2021.
//

import Foundation
import Amplify
import AmplifyPlugins

class SessionManager {
    
    static let shared = SessionManager()
    private var isSignedIn :Bool?
    
    init() {
        isSignedIn = false
    }
    
    func hasSession() -> Bool {
        return isSignedIn ?? false
    }
    
    func setSignedIn(_ isSignedIn :Bool) {
        self.isSignedIn = isSignedIn
    }
}

//=================================================================================================

typealias ActionBlock = () -> Void

class AmplifyManager {
    
    func configure() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        fetchCurrentAuthSession()
    }
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
                SessionManager.shared.setSignedIn(session.isSignedIn)
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    static func signIn(username :String, password :String, completion :ActionBlock?) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                SessionManager.shared.setSignedIn(true)
                if let action = completion {
                    action()
                }
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    static func signOut() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")
                SessionManager.shared.setSignedIn(false)
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    static func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    static func confirmSignUp(for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
                SessionManager.shared.setSignedIn(true)
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
            }
        }
    }
}
