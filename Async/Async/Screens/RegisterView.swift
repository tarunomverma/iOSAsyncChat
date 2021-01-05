//
//  RegisterView.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

protocol RegisterViewDelegate :class {
    func getCodeTapped(username :String, email :String, password :String)
    func registerTapped(username :String, code :String)
    func signOutTapped()
}

class RegisterView :UIView {
    
    let label = Label("Register")
    let nameTextField = TextField("Username")
    let emailTextField = TextField("Email")
    let passwordTextField = TextField("Password")
    let getCodeButton = Button("Get code")
    let divider = UIView()
    let codeTextField = TextField("Code")
    let registerButton = Button("Register")
    let stackView = UIStackView()
    
    let usernameLabel = Label()
    let signOutButton = Button("Sign out")
    
    weak var delegate :RegisterViewDelegate?
    
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
        divider.backgroundColor = UIColor.darkGray
        divider.height(1)
        
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
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(getCodeButton)
        stackView.setCustomSpacing(24, after: getCodeButton)
        stackView.addArrangedSubview(divider)
        stackView.setCustomSpacing(24, after: divider)
        stackView.addArrangedSubview(codeTextField)
        stackView.addArrangedSubview(registerButton)
        
        getCodeButton.addTarget(self, action: #selector(getCodeTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    @objc func getCodeTapped() {
        if let username = nameTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            delegate?.getCodeTapped(username: username, email: email, password: password)
        }
    }
    
    @objc func registerTapped() {
        if let username = nameTextField.text,
           let code = codeTextField.text {
            delegate?.registerTapped(username: username, code: code)
            nameTextField.setText("")
            emailTextField.setText("")
            codeTextField.setText("")
            passwordTextField.setText("")
        }
    }
    
    @objc func signOutTapped() {
        delegate?.signOutTapped()
    }
    
    func configure(_ hasSession :Bool) {
        stackView.isHidden = hasSession ? true : false
        signOutButton.isHidden = hasSession ? false : true
        usernameLabel.isHidden = hasSession ? false : true
        usernameLabel.text = "Hello " + SessionManager.shared.getUsername()
    }
}
