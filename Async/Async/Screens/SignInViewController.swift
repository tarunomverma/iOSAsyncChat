//
//  SignInViewController.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit
import TinyConstraints

class SignInViewController :UIViewController {

    let signInView = SignInView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signInView)
        signInView.edgesToSuperview()
        signInView.delegate = self
        signInView.configure(SessionManager.shared.hasSession())
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInView.configure(SessionManager.shared.hasSession())
    }
}

extension SignInViewController :SignInViewDelegate {
    
    func signInTapped(username :String, password :String) {
        AmplifyManager.signIn(username: username, password: password) {
            self.signInView.configure(SessionManager.shared.hasSession())
        }
    }
    
    func signOutTapped() {
        AmplifyManager.signOut()
    }
}
