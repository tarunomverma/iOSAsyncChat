//
//  SignInView.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit

protocol SignInViewDelegate :class {
    func signInTapped(username :String, password :String)
    func signOutTapped()
}

class SignInView :UIView {
    
    let label = Label("SignIn")
    let nameTextField = TextField("Username")
    let passwordTextField = TextField("Password")
    let signInButton = Button("SignIn")
    let stackView = UIStackView()
    
    let usernameLabel = Label()
    let signOutButton = Button("Sign out")
    
    weak var delegate :SignInViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupStackView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        passwordTextField.isSecureTextEntry = true
        addSubview(stackView)
        addSubview(signOutButton)
        signOutButton.isHidden = true
        addSubview(usernameLabel)
        usernameLabel.isHidden = true
        
        stackView.topToSuperview(offset: 100)
        stackView.leftToSuperview(offset: 24)
        stackView.rightToSuperview(offset: -24)
        
        usernameLabel.topToSuperview(offset: 100)
        usernameLabel.leftToSuperview(offset: 24)
        usernameLabel.rightToSuperview(offset: -24)
        
        signOutButton.centerYToSuperview()
        signOutButton.leftToSuperview(offset: 24)
        signOutButton.rightToSuperview(offset: -24)
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    func setupStackView() {
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    
    @objc func signInTapped() {
        if let username = nameTextField.text,
           let password = passwordTextField.text {
            delegate?.signInTapped(username: username, password: password)
            nameTextField.setText("")
            passwordTextField.setText("")
        }
    }
    
    @objc func signOutTapped() {
        delegate?.signOutTapped()
    }
    
    func configure(_ hasSession :Bool) {
        DispatchQueue.main.async {
            self.stackView.isHidden = hasSession ? true : false
            self.signOutButton.isHidden = hasSession ? false : true
            self.usernameLabel.isHidden = hasSession ? false : true
            self.usernameLabel.text = "Hello " + SessionManager.shared.getUsername()
        }
    }
}
