//
//  StartChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class StartChatViewController :UIViewController {
    
    let startChatView = StartChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startChatView)
        startChatView.emptyView.delegate = self
        startChatView.edgesToSuperview()
    }
}

extension StartChatViewController :EmptyViewDelegate {
    
    func ctaTapped() {
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
