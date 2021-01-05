//
//  Models.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import Foundation

struct EmptyResponse :Codable {
    init() { }
}

struct StartConversationParam :Codable {
    let name :String?
}

struct StartConversationResponse :Codable {
    let conversationId :String?
}

struct ConversationsResponse :Codable {
    let id :String?
    let last :Int?
    let participants :[String]?
    var messages :[Message]?
    
    func getSenderName() -> String{
        if let participants = participants {
            for p in participants {
                if p != SessionManager.shared.getUsername() {
                    return p
                }
            }
        }
        return ""
    }
}

struct AsyncResponse :Codable {
    let messages :[Message]?
}

struct Message :Codable {
    let sender :String?
    let message :String?
    let time :Int?
    
    func messageType() -> MessageType {
        if sender == SessionManager.shared.getUsername() {
            return .sent
        }
        return .received
    }
}

enum MessageType {
    case sent
    case received
}


struct StaffResponse :Codable {
    let staff :[String]?
}
