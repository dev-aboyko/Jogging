//
//  APILogin.swift
//  Jogging
//
//  Created by Alexey Boyko on 10/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class APILogin: RestAPIpost {

    var token: String? {  return json?["idToken"].string   }
    var refreshToken: String? { return json?["refreshToken"].string }
    var userId: String? { return json?["localId"].string }
    var expiresIn: TimeInterval? { return TimeInterval(json?["expiresIn"].string ?? "") }
    
    init(email: String, password: String) {
        let credentials: Dictionary<String, Any> = ["email" : email, "password" : password, "returnSecureToken" : true]
        let urlString = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=\(Config.apiKey)"
        super.init(urlString: urlString, parameters: credentials)
    }
    
}
