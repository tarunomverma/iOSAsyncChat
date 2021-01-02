//
//  StartChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class StartChatViewController :UIViewController {
    
    let startChatView = StartChatView()
    var response :AsyncResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startChatView)
        startChatView.emptyView.delegate = self
        startChatView.edgesToSuperview()
    }
    
    func getConversations() {
        API().getConversations { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                self.response = response
                self.toChatVC()
            }
        }
    }
    
    func toChatVC() {
        if let response = response {
            let vc = ChatViewController(response: response)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension StartChatViewController :EmptyViewDelegate {
    
    func ctaTapped() {
        getConversations()
    }
}
