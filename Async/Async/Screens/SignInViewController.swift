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
        hideKeyboardOnTap()
    }

}
