//
//  MainView.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit

class MainView :UIView {
    
    let nameTextField = TextField()
    let passwordTextField = TextField()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        nameTextField.placeholder = "Enter name"
        passwordTextField.placeholder = "Enter password"
        
        addSubview(nameTextField)
        addSubview(passwordTextField)
        
        nameTextField.topToSuperview(offset: 100)
        nameTextField.leftToSuperview(offset: 24)
        nameTextField.rightToSuperview(offset: -24)
        nameTextField.height(35)
        
        passwordTextField.topToBottom(of: nameTextField, offset: 12)
        passwordTextField.leftToSuperview(offset: 24)
        passwordTextField.rightToSuperview(offset: -24)
        passwordTextField.height(35)
    }
}



class TextField :UITextField {
    
    init() {
        super.init(frame: .zero)
//        NSDirectionalEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 2)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
