//
//  APILogin.swift
//  Jogging
//
//  Created by Alexey Boyko on 10/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class APILogin: RestAPI {

    var token: String?
    var refreshToken: String?
    var userId: String?
    var expiresIn: Int?
    
    init(email: String, password: String) {
        let credentials: Dictionary<String, Any> = ["email" : email, "password" : password, "returnSecureToken" : true]
        let urlString = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=\(Config.apiKey)"
        super.init(urlString: urlString, parameters: credentials, method: .post)
    }
    
    override func processSuccess(json: JSON) {
        Log.message("\(json)")
        guard
            let expiresInStr = json["expiresIn"].string,
            let expiresIn = Int(expiresInStr),
            let token = json["idToken"].string,
            let refreshToken = json["refreshToken"].string,
            let userId = json["localId"].string
        else {
            isSuccessfull = false
            return
        }
        self.token = token
        self.refreshToken = refreshToken
        self.userId = userId
        self.expiresIn = expiresIn
    }
    
}
