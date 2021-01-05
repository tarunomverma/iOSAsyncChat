//
//  StaffListViewController.swift
//  Async
//
//  Created by Tarun Verma on 04/01/2021.
//

import UIKit

class StaffListViewController :UIViewController {
    
    let staffView = StaffListView()
    var response :StaffResponse?
    
    convenience init(response :StaffResponse) {
        self.init()
        self.response = response
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a doctor to chat"
        view.backgroundColor = .white
        view.addSubview(staffView)
        staffView.configure(response: response)
        staffView.delegate = self
        hideKeyboardOnTap()
        addCancelButton()
        staffView.edgesToSuperview()
    }
    
    func startConversation(name :String) {
        API().startConversation(with: name) { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                print("error")
                print(response)
                self.toChatVC(id: response.conversationId, name :name)
            }
        }
    }
    
    func toChatVC(id :String?, name :String) {
        if let id = id {
            DispatchQueue.main.async {
                let vc = ChatViewController(id: id, name: name)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension StaffListViewController :StaffListViewDelegate {
    
    func itemTapped(name: String) {
        startConversation(name: name)
    }
}
