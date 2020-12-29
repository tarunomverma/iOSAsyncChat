//
//  RegisterViewController.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class RegisterViewController :UIViewController {
    
    let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.edgesToSuperview()
        hideKeyboardOnTap()
    }
}
