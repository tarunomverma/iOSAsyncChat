//
//  StartChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class StartChatViewController :UIViewController {
    
    let startChatView = StartChatView()
    var conversationsResponse :[ConversationsResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startChatView)
        startChatView.chatListView.delegate = self
        setupConstraints()
        getConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConversations()
        startChatView.configure(SessionManager.shared.hasSession(), response: conversationsResponse)
    }
    
    func setupConstraints() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        startChatView.edgesToSuperview(excluding: .bottom)
        startChatView.bottomToSuperview(offset: -tabBarHeight)
    }
    
    func getConversations() {
        API().getConversations { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                self.conversationsResponse = response
                self.startChatView.configure(SessionManager.shared.hasSession(), response: self.conversationsResponse)
            }
        }
    }

    func getConversationById(id: String) {
        API().getConversationById(id: id) { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                print("error")
                self.toChatVC(response: response)
            }
        }
    }
    
    func getStaff() {
        API().getStaff { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                self.toStaffListVC(response: response)
            }
        }
    }
}

extension StartChatViewController :ChatListViewDelegate {
    
    func newChatButtonTapped() {
        getStaff()
    }
    
    func chatTapped(id: String) {
        getConversationById(id: id)
    }
}

extension StartChatViewController {
    
    func toChatVC(response :ConversationsResponse) {
        DispatchQueue.main.async {
            let vc = ChatViewController(response: response)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func toStaffListVC(response :StaffResponse) {
        DispatchQueue.main.async {
            let vc = StaffListViewController(response: response)
            vc.hidesBottomBarWhenPushed = true
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
        }
    }
}
