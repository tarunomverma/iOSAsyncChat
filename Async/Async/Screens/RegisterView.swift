//
//  RegisterView.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class RegisterView :UIView {
    
    let label = Label("Register")
    let nameTextField = TextField("Username")
    let emailTextField = TextField("Email")
    let passwordTextField = TextField("Password")
    let getCodeCTA = Button("Get code")
    let divider = UIView()
    let codeTextField = TextField("Code")
    let registerCTA = Button("Register")
    let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {        
        divider.backgroundColor = UIColor.darkGray
        divider.height(1)
        
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(getCodeCTA)
        stackView.setCustomSpacing(24, after: getCodeCTA)
        stackView.addArrangedSubview(divider)
        stackView.setCustomSpacing(24, after: divider)
        stackView.addArrangedSubview(codeTextField)
        stackView.addArrangedSubview(registerCTA)
        
        stackView.topToSuperview(offset: 100)
        stackView.leftToSuperview(offset: 24)
        stackView.rightToSuperview(offset: -24)
    }
}
