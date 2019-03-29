//
//  APIClient.swift
//  TDD_iOS_ToDo
//
//  Created by venD-vijay on 28/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import UIKit

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}



enum WebserviceError: Error {
    case DataEmptyError
}

class APIClient: NSObject {
    var session: SessionProtocol?
    
    func loginUser(withName username: String, password: String, completion: @escaping (Token?, Error?) -> Void) {
        
        let query = "username=\(username.percentEncode)&password=\(password.percentEncode)"
        guard let url = URL(string: "https://awesometodos.com/login?\(query)") else { fatalError() }
        _ = session?.dataTask(with: url, completionHandler: { (data, urlresponse, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let dataReturned = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: dataReturned, options: []) as? [String:String]
                let token: Token?
                if let tokenString = dict?["token"] {
                    token = Token(id: tokenString)
                } else {
                    token = nil
                }
                completion(token, nil)
            }
            catch {
                completion(nil, error)
            }
        }).resume()
    }
}

extension URLSession: SessionProtocol {}

extension String {
    var percentEncode: String {
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        return encoded
    }
}
