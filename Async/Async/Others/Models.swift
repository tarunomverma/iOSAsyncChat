//
//  Models.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import Foundation

struct AsyncResponse :Codable {
    let messages :[Message]?
}

struct Message :Codable {
    let sender :String?
    let message :String?
    let time :String?
    
    func messageType() -> MessageType {
        if sender == "lgc" {
            return .received
        }
        return .sent
    }
}

enum MessageType {
    case sent
    case received
}
