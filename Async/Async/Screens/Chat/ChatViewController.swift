//
//  ChatViewController.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class ChatViewController :UIViewController {
    
    let chatView = ChatView()
    var response :ConversationsResponse?
    var id :String?
    var chatTimer :Timer?
    var startTimer = false
    
    convenience init(response :ConversationsResponse) {
        self.init()
        self.response = response
        title = response.getSenderName()
    }
    
    convenience init(id :String, name :String) {
        self.init()
        self.id = id
        title = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(chatView)
        chatView.configure(response: response)
        chatView.delegate = self
        hideKeyboardOnTap()
        chatView.edgesToSuperview()
        
        chatTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getConversation), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func getConversation() {
        if startTimer {
            if let id = response?.id {
                getConversationById(id: id)
            } else if let id = id {
                getConversationById(id: id)
            }
        }
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5, animations: {
                self.chatView.keyboardWillShow(show: true, keyboardHeight: keyboardSize.height)
            })
        }
    }

    @objc func keyboardWillHide() {
        chatView.keyboardWillShow(show: false, keyboardHeight: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let messages = response?.messages, messages.count > 0 {
            DispatchQueue.main.async {
                self.chatView.tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatTimer?.invalidate()
    }
    
    func continueConversationById(id: String, message :String) {
        API().continueConversationById(id: id, message: message) { result in
            switch result {
            case .failure(_):
                print("error")
            case .success(_):
                print("success")
            }
        }
    }
    
    func getConversationById(id: String) {
        API().getConversationById(id: id) { result in
            switch result {
            case .failure(_):
                print("error")
            case let .success(response):
                print("success")
                self.chatView.configure(response: response)
            }
        }
    }
}

extension ChatViewController :ChatViewDelegate {
 
    func sendTapped(message: String) {
        startTimer = true
        if let id = response?.id {
            continueConversationById(id: id, message: message)
        } else if let id = id {
            continueConversationById(id: id, message: message)
            getConversationById(id: id)
        }
    }
}
