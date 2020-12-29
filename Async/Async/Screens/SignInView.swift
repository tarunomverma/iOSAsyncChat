//
//  SignInView.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit

class SignInView :UIView {
    
    let label = Label("SignIn")
    let nameTextField = TextField("Username")
    let passwordTextField = TextField("Password")
    let cta = Button("SignIn")
    let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(cta)
        
        stackView.topToSuperview(offset: 100)
        stackView.leftToSuperview(offset: 24)
        stackView.rightToSuperview(offset: -24)
    }
}
