//
//  ChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class ChatViewController :UIViewController {
    
    let chatView = ChatView()
    var response :AsyncResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(chatView)
        self.response = MockHelper().getResponse()
        chatView.configure(response: response)
        hideKeyboardOnTap()
        chatView.edgesToSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let messages = response?.messages {
            DispatchQueue.main.async {
                self.chatView.tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
}
