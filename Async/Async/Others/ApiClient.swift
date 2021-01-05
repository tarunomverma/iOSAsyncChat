//
//  ApiClient.swift
//  Async
//
//  Created by Tarun Verma on 31/12/2020.
//

import Foundation

enum APIError :Error {
    case inernalError
    case serverError
    case parsingError
}

class API {
    
    private let baseURL = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod"
    
    private enum Endpoint {
        static let getConversations = "​​/conversations"
        static let getStaff = "/staff"
    }
    
    private enum Method :String {
        case GET
        case POST
    }
    
    private func request<T :Codable>(urlString :String, method :Method, requestBody :Data? = nil, completion: @escaping((Result<T, APIError>) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        
        if SessionManager.shared.getAuthToken() == nil {
            AmplifyManager().fetchCurrentAuthSession() {
                var request = URLRequest(url: url)
                request.httpMethod = "\(method)"
                request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                               "authorization": SessionManager.shared.getAuthToken() ?? ""]
                request.httpBody = requestBody
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard error == nil else {
                        completion(.failure(.serverError))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(.serverError))
                        return
                    }
                    
                    guard let response :T = JsonHelper.decode(T.self, from: data) else {
                        completion(.failure(.parsingError))
                        return
                    }
                    
                    completion(.success(response))
                }
                task.resume()
            }
        } else if let auth = SessionManager.shared.getAuthToken() {
            var request = URLRequest(url: url)
            request.httpMethod = "\(method)"
            request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                           "authorization":auth]
            request.httpBody = requestBody
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(.failure(.serverError))
                    return
                }

                guard let data = data else {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let response :T = JsonHelper.decode(T.self, from: data) else {
                    completion(.failure(.parsingError))
                    return
                }
                
                completion(.success(response))
            }
            task.resume()
        }
    }
}

extension API {
    
    func getConversations(completion :@escaping ((Result<[ConversationsResponse], APIError>) -> Void)) {
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/conversations"
        request(urlString: urlString, method :.GET, completion: completion)
    }
    
    func startConversation(with name :String, completion :@escaping ((Result<StartConversationResponse, APIError>) -> Void)) {
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/conversations"
        let body = JsonHelper.convertToData([name])
        request(urlString: urlString, method :.POST, requestBody: body, completion: completion)
    }
    
    func continueConversationById(id: String, message :String, completion :@escaping ((Result<EmptyResponse, APIError>) -> Void)) {
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/conversations/\(id)"
        let message: Data? = message.data(using: .utf8)
        request(urlString: urlString, method :.POST, requestBody: message, completion: completion)
    }
    
    func getConversationById(id: String, completion :@escaping ((Result<ConversationsResponse, APIError>) -> Void)) {
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/conversations/\(id)"
        request(urlString: urlString, method :.GET, completion: completion)
    }
    
    func getStaff(completion :@escaping ((Result<StaffResponse, APIError>) -> Void)) {
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/staff"
        request(urlString: urlString, method :.GET, completion: completion)
    }
}
