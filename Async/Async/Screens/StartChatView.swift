//
//  StartChatView.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

protocol EmptyViewDelegate :class {
    func ctaTapped()
}

class EmptyView :UIView {
    
    let label = LightLabel("Please sign in first to start chat.")
    let cta = Button("Start chat")
    weak var delegate :EmptyViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        addSubview(cta)
        
        label.textAlignment = .center
        label.centerYToSuperview()
        label.leftToSuperview()
        label.rightToSuperview()
        
        cta.topToBottom(of: label, offset: 30)
        cta.leftToSuperview(offset: 24)
        cta.rightToSuperview(offset: -24)
        cta.addTarget(self, action: #selector(ctaTapped), for: .touchUpInside)
    }
    
    @objc func ctaTapped() {
        delegate?.ctaTapped()
    }
}

class StartChatView :UIView {
    
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
