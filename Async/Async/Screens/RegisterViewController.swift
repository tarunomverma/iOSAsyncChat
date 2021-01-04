//
//  RegisterViewController.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit
import Amplify

class RegisterViewController :UIViewController {
    
    let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.edgesToSuperview()
        registerView.delegate = self
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerView.configure(SessionManager.shared.hasSession())
    }
}

extension RegisterViewController :RegisterViewDelegate {
    
    func getCodeTapped(username :String, email :String, password :String) {
        AmplifyManager.signUp(username: username, password: password, email: email)
    }
    
    func registerTapped(username :String, code :String) {
        AmplifyManager.confirmSignUp(for: username, with: code)
    }
    
    func signOutTapped() {
        AmplifyManager.signOut()
    }
}
