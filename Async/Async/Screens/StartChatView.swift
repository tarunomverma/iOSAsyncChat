//
//  StartChatView.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import UIKit

class ChatListCell :UITableViewCell {
    
    let nameLabel = SixteenLabel("Dr. LGC")
    let timeLabel = TwelveLightLabel("")
    let divider = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(timeLabel)
        addSubview(divider)
    }
    
    func setupConstraints() {
        nameLabel.topToSuperview(offset: 12)
        nameLabel.leftToSuperview(offset: 12)
        
        timeLabel.topToSuperview(offset: 12)
        timeLabel.leftToRight(of: nameLabel, offset: 12)
        timeLabel.rightToSuperview(offset: -12)
        timeLabel.bottom(to: nameLabel)
        
        divider.topToBottom(of: nameLabel, offset: 12)
        divider.leftToSuperview(offset: 12)
        divider.rightToSuperview(offset: -12)
        divider.bottomToSuperview()
    }
    
    func configure(_ item :ConversationsResponse) {
        if let participants = item.participants {
            for p in participants {
                if p != SessionManager.shared.getUsername() {
                    nameLabel.setText(p)
                    break
                }
            }
        }
        timeLabel.setText(Date().getDateTime(timeStamp: item.last))
    }
    
    func configure(_ name :String) {
        nameLabel.setText(name)
    }
}

//=================================================================================================

protocol ChatListViewDelegate :class {
    func newChatButtonTapped()
    func chatTapped(id :String)
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
    
    func configure(response :[ConversationsResponse]) {
        self.response = response
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChatListView :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatListCell,
              let res = response?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(res)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatId = response?[indexPath.row].id else { return }
        delegate?.chatTapped(id: chatId)
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
    
    func configure(_ hasSession :Bool, response :[ConversationsResponse]?) {
        DispatchQueue.main.async {
            self.label.isHidden = hasSession ? true : false
            self.chatListView.isHidden = hasSession ? false : true
            if let response = response, !response.isEmpty {
                self.chatListView.configure(response: response)
            }
        }
    }
}
