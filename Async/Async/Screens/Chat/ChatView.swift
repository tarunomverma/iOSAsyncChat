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
    
        timeLabel.topToBottom(of: container, offset: 5)
        timeLabel.bottomToSuperview()
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
        timeLabel.setText(message.time ?? "")
        setupForType(message.messageType())
    }
    
}

//=================================================================================================

class ChatView :UIView {
    
    let tableView = UITableView()
    let textView = TextInputView()
    var response :AsyncResponse?
    
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
        addSubview(textView)
        
        tableView.topToSuperview()
        tableView.leftToSuperview(offset: 12)
        tableView.rightToSuperview(offset: -12)
        
        textView.height(100)
        textView.topToBottom(of: tableView, offset: 12)
        textView.bottomToSuperview()
        textView.leftToSuperview()
        textView.rightToSuperview()
    }
    
    func setupTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func configure(response :AsyncResponse?) {
        self.response = response
        tableView.reloadData()
    }
    
}

extension ChatView :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.messages?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell,
              let res = response else {
            return UITableViewCell()
        }
        if let msg = res.messages?[indexPath.row] {
            cell.configure(message: msg)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
