//
//  ChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class ChatViewController :UIViewController {
    
    let chatView = ChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(chatView)
        chatView.edgesToSuperview()
    }
}
