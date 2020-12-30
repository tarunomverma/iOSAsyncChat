//
//  Helpers.swift
//  Async
//
//  Created by Tarun Verma on 30/12/2020.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    
    var isLoggedIn :Bool?
    
    init() {
        isLoggedIn = false
    }
    
    func hasSession() -> Bool {
        return isLoggedIn ?? false
    }

}

//=================================================================================================

class MockHelper {
    
    func createMockResponse<T: Decodable>(fileName :String, responseType :T.Type) -> T? {
        let testBundle = Bundle(for: type(of: self))
        guard let resourceURL = testBundle.url(forResource: fileName, withExtension: "json") else {
            // file does not exist
            return nil
        }
        do {
            let data = try Data(contentsOf: resourceURL)
            let response = JsonHelper.decode(responseType.self, from: data)
            return response
        } catch _ {
            return nil
        }
    }
    
    func getResponse() -> AsyncResponse? {
        let response = MockHelper().createMockResponse(fileName: "asyncResponse", responseType: AsyncResponse.self)
        return response
    }
}

//=================================================================================================

class JsonHelper {
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let err{
            print("Session Error: ",err)
        }
        return nil
    }
}
