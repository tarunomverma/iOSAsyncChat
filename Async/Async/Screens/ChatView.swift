//
//  ChatView.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class EmptyView :UIView {
    
    let label = LightLabel("Please sign in first to start chat.")
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        label.textAlignment = .center
        label.centerYToSuperview()
        label.leftToSuperview()
        label.rightToSuperview()
    }
}

class ChatView :UIView {
    
    let emptyView = EmptyView()
    
    init() {
        super.init(frame: .zero)
        if SessionManager.shared.hasSession() {
            setupEmptyView()
        } else {
            setupEmptyView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEmptyView() {
        addSubview(emptyView)
        emptyView.edgesToSuperview()
    }
    
}
