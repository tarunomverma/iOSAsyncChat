//
//  ChatView.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class TableViewCell :UITableViewCell {
    
    let msgLabel = MediumLightLabel()
    let container = UIView()
    let timeLabel = SmallLightLabel()
    
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
        msgLabel.textColor = .white
        msgLabel.numberOfLines = 0
        container.layer.cornerRadius = 5
        container.addSubview(msgLabel)
        addSubview(container)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        msgLabel.topToSuperview(offset: 10)
        msgLabel.bottomToSuperview(offset: -10)
        msgLabel.leftToSuperview(offset: 10)
        msgLabel.rightToSuperview(offset: -10)
        
        container.topToSuperview()
    
        timeLabel.topToBottom(of: container, offset: 3)
        timeLabel.bottomToSuperview(offset: -5)
        timeLabel.leftToSuperview(offset: 0)
        timeLabel.rightToSuperview(offset: 0)
    }
    
    func setupForType(_ type :MessageType) {
        switch type {
        case .sent:
            container.rightToSuperview()
            container.leftToSuperview(offset: 24, relation: .equalOrGreater, priority: .defaultHigh)
            container.backgroundColor = Colors.paleBlue
            msgLabel.textAlignment = .right
            timeLabel.textAlignment = .right
        case .received:
            container.leftToSuperview()
            container.rightToSuperview(offset: -24, relation: .equalOrLess, priority: .defaultHigh)
            container.backgroundColor = Colors.paleGreen
            timeLabel.textAlignment = .left
            timeLabel.textAlignment = .left
        }
    }
    
    func configure(message :Message) {
        msgLabel.setText(message.message ?? "")
        timeLabel.setText(Date().getTime(timeStamp: message.time))
        setupForType(message.messageType())
    }
}

//=================================================================================================

protocol ChatViewDelegate :class {
    func sendTapped(message :String)
}

class ChatView :UIView {
    
    let tableView = UITableView()
    let textView = TextInputView()
    
    weak var delegate :ChatViewDelegate?
    var response :ConversationsResponse?
    var bottomConstraint :NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        textView.delegate = self
        setup()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(tableView)
        addSubview(textView)
        
        tableView.topToSuperview()
        tableView.leftToSuperview(offset: 12)
        tableView.rightToSuperview(offset: -12)
        
        textView.height(100)
        textView.topToBottom(of: tableView, offset: 0)
        textView.leftToSuperview()
        textView.rightToSuperview()
        bottomConstraint = textView.bottomToSuperview(offset: 0)
    }
    
    func setupTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func keyboardWillShow(show :Bool, keyboardHeight :CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            if show {
                self.bottomConstraint?.constant = -keyboardHeight
            } else {
                self.bottomConstraint?.constant = 0
            }
            self.layoutIfNeeded()
        })
    }
    
    func configure(response :ConversationsResponse?) {
        DispatchQueue.main.async {
            self.response = response
            self.tableView.reloadData()
        }
    }
}

extension ChatView :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.messages?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell,
              let message = response?.messages?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ChatView :TextInputViewDelegate {
    
    func sendTapped(message: Message) {
        if let msg = message.message {
            delegate?.sendTapped(message: msg)
            self.response?.messages?.append(message)
            tableView.reloadData()
        }
    }
}
