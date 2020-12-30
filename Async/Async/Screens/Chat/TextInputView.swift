//
//  TextInputView.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class TextInputView :UIView {
    
    let textField = TextField("Start a message...")
    let icon = UIImageView(image: UIImage(named: "sendIcon"))
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.paleGrey
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .white
        addSubview(textField)
        addSubview(icon)
        
        textField.topToSuperview(offset: 12)
        textField.bottomToSuperview(offset: -12 - bottomSafeAreaInset())
        textField.leftToSuperview(offset: 12)
        
        icon.topToSuperview(offset: 12)
        icon.leftToRight(of: textField, offset: 12)
        icon.rightToSuperview(offset: -12)
        icon.bottomToSuperview(offset: -12 - bottomSafeAreaInset())
    }
}
