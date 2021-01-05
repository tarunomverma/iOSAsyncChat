//
//  StaffListView.swift
//  Async
//
//  Created by Tarun Verma on 04/01/2021.
//

import UIKit

protocol StaffListViewDelegate :class {
    func itemTapped(name :String)
}

class StaffListView :UIView {
    
    let tableView = UITableView()
    weak var delegate :StaffListViewDelegate?
    var response :StaffResponse?
    
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
        tableView.topToSuperview()
        tableView.leftToSuperview(offset: 12)
        tableView.rightToSuperview(offset: -12)
        tableView.bottomToSuperview(offset: -12)
    }
    
    func setupTableView() {
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func configure(response :StaffResponse?) {
        self.response = response
        tableView.reloadData()
    }
}

extension StaffListView :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response?.staff?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatListCell,
              let name = response?.staff?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = response?.staff?[indexPath.row] else { return }
        delegate?.itemTapped(name: name)
    }
}
