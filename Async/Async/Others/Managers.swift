//
//  Managers.swift
//  Async
//
//  Created by Tarun Verma on 03/01/2021.
//

import Foundation
import Amplify
import AmplifyPlugins
import AWSPluginsCore

class SessionManager {
    
    static let shared = SessionManager()
    private var isSignedIn :Bool?
    private var authToken :String?
    private var username :String?
    
    init() {
        isSignedIn = false
    }
    
    func hasSession() -> Bool {
        return isSignedIn ?? false
    }
    
    func setSignedIn(_ isSignedIn :Bool) {
        self.isSignedIn = isSignedIn
    }
    
    func setAuthToken(_ authToken :String) {
        self.authToken = authToken
    }
    
    func getAuthToken() -> String {
        return authToken ?? ""
    }
    
    func setUsername(_ username :String) {
        self.username = username
    }
    
    func getUsername() -> String {
        return username ?? ""
    }
    
    func clearToken() {
        self.authToken = nil
        self.username = nil
        self.isSignedIn = false
    }
}

//=================================================================================================

typealias ActionBlock = () -> Void

class AmplifyManager {
    
    static var signUpPassword :String?
    
    func configure() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        fetchCurrentAuthSession()
    }
    
    func fetchCurrentAuthSession() {
//        _ = Amplify.Auth.fetchAuthSession { result in
            Amplify.Auth.fetchAuthSession { result in
                do {
                    let session = try result.get()
                    if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                        let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                        print("Id token - \(tokens.idToken) ")
                        SessionManager.shared.setAuthToken(tokens.idToken)
                        
                        print("Is user signed in - \(session.isSignedIn)")
                        SessionManager.shared.setSignedIn(session.isSignedIn)
                        SessionManager.shared.setUsername(Amplify.Auth.getCurrentUser()?.username ?? "")
                    }
                } catch {
                    print("Fetch auth session failed with error - \(error)")
                }
            }
            
            
            
//            switch result {
//            case .success(let session):
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                    do {
//                        let session1 = try result.get()
//                        if let cognitoTokenProvider = session1 as? AuthCognitoTokensProvider {
//                            let tokens = try cognitoTokenProvider.getCognitoTokens().get()
//                            print("Id token - \(tokens.idToken) ")
//                            SessionManager.shared.setAuthToken(tokens.idToken)
//                        }
//                    }
//                    catch { }
//
//                }
//
//                print("Is user signed in - \(session.isSignedIn)")
//                SessionManager.shared.setSignedIn(session.isSignedIn)
//                SessionManager.shared.setUsername(Amplify.Auth.getCurrentUser()?.username ?? "")
//            case .failure(let error):
//                print("Fetch session failed with error \(error)")
//            }
        
    }
    
    static func signIn(username :String, password :String, completion :ActionBlock?) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                SessionManager.shared.setSignedIn(true)
                SessionManager.shared.setUsername(Amplify.Auth.getCurrentUser()?.username ?? "")
                AmplifyManager().fetchCurrentAuthSession()
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
                SessionManager.shared.clearToken()
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
                self.signUpPassword = password
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
//                SessionManager.shared.setSignedIn(true)
//                SessionManager.shared.setUsername(Amplify.Auth.getCurrentUser()?.username ?? "")
//
                signIn(username: username, password: signUpPassword ?? "Qwerty22") {
//                    AmplifyManager().fetchCurrentAuthSession()
                }
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
            }
        }
    }
}
