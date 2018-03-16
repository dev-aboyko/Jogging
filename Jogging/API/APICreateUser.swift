//
//  APICreateUser.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class APICreateUser: RestAPIpost {

    var userId: String? { return json?["localId"].string }
    
    init(email: String, password: String) {
        let credentials: Dictionary<String, Any> = ["email" : email, "password" : password, "returnSecureToken" : true]
        let urlString = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=\(Config.apiKey)"
        super.init(urlString: urlString, parameters: credentials)
    }
    
}
