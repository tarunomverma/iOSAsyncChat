//
//  StartChatView.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class ChatListCell :UITableViewCell {
    
    let nameLabel = SixteenLabel("Dr. LGC")
    let divider = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        setup()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        divider.backgroundColor = UIColor.lightGray
        divider.height(1)
        
        addSubview(nameLabel)
        addSubview(divider)
    }
    
    func setupConstraints() {
        nameLabel.topToSuperview(offset: 12)
        nameLabel.leftToSuperview(offset: 12)
        nameLabel.rightToSuperview(offset: -12)
        
        divider.topToBottom(of: nameLabel, offset: 12)
        divider.leftToSuperview(offset: 12)
        divider.rightToSuperview(offset: -12)
        divider.bottomToSuperview()
    }
    
    func configure(_ item :ConversationsResponse) {
        nameLabel.setText("Dr. LGC")
    }
}

//=================================================================================================

protocol ChatListViewDelegate :class {
    func newChatButtonTapped()
}

class ChatListView :UIView {
    
    let tableView = UITableView()
    let newChatButton = Button("Start new chat")
    
    weak var delegate :ChatListViewDelegate?
    var response :[ConversationsResponse]?
    
    init() {
        super.init(frame: .zero)
        setup()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(tableView)
        addSubview(newChatButton)
        
        tableView.topToSuperview()
        tableView.leftToSuperview(offset: 12)
        tableView.rightToSuperview(offset: -12)
        
        newChatButton.topToBottom(of: tableView, offset: 12)
        newChatButton.leftToSuperview(offset: 24)
        newChatButton.rightToSuperview(offset: -24)
        newChatButton.bottomToSuperview(offset: -24)
        newChatButton.addTarget(self, action: #selector(newChatButtonTapped), for: .touchUpInside)
    }
    
    func setupTableView() {
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    @objc func newChatButtonTapped() {
        delegate?.newChatButtonTapped()
    }
}

extension ChatListView :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatListCell
//              let response = response
        else {
            return UITableViewCell()
        }
        
        // how to check if value for this index exists.?
        if let res = response?[indexPath.row] {
            cell.configure(res)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//=================================================================================================

class StartChatView :UIView {
    
    let label = LightLabel("Please sign in first to start chat.")
    let chatListView = ChatListView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        addSubview(chatListView)
        
        label.textAlignment = .center
        label.centerYToSuperview()
        label.leftToSuperview()
        label.rightToSuperview()
        
        chatListView.edgesToSuperview()
    }
    
    func configure(_ hasSession :Bool) {
        label.isHidden = hasSession ? true : false
        chatListView.isHidden = hasSession ? false : true
    }
}
