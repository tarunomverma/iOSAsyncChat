//
//  Extensions.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
