//
//  UIElements.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class Label :UILabel {
    
    init(_ text :String) {
        super.init(frame: .zero)
        attributedText = NSAttributedString(string: text)
        layer.cornerRadius = 5
        font = UIFont.boldSystemFont(ofSize: 24)
        height(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//==========================================================================================================================

class TextField :UITextField {

    let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    init(_ placeholder :String) {
        super.init(frame: .zero)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        autocorrectionType = .no
        self.placeholder = placeholder
        height(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
}

//==========================================================================================================================

class Button :UIButton {
    
    init(_ title :String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 5
        setTitle(title, for: .normal)
        height(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
