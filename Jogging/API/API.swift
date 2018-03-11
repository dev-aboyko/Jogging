//
//  API.swift
//  Jogging
//
//  Created by Alexey Boyko on 11/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class API {
    
    static func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        let apiLogin = APILogin(email: email, password: password)
        apiLogin.connect {
            if apiLogin.isSuccessfull {
                getUserRole(apiLogin: apiLogin, completion: completion)
            } else {
                completion(apiLogin.statusDescription ?? "APILogin Error")
            }
        }
    }
    
    private static func getUserRole(apiLogin: APILogin, completion: @escaping (String?) -> Void) {
        
    }
    
}
