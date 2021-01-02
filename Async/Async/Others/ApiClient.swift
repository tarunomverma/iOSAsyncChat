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
    
    private func request<T :Codable>(urlString :String, method :Method, completion: @escaping((Result<T, APIError>) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
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

extension API {
    
    func getConversations(completion :@escaping ((Result<AsyncResponse, APIError>) -> Void)) {
//        let urlString = String(baseURL + Endpoint.getConversations)
        let urlString = "https://636iy5po1c.execute-api.us-east-1.amazonaws.com/prod/conversations"
        request(urlString: urlString, method :.GET, completion: completion)
    }
}
