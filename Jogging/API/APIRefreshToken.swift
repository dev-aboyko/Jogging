//
//  APIRefreshToken.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class APIRefreshToken: RestAPIpost {

    var token: String? {  return json?["id_token"].string   }
    var refreshToken: String? { return json?["refresh_token"].string }
    var expiresIn: TimeInterval? { return TimeInterval(json?["expires_in"].string ?? "") }

    init(refreshToken: String) {
        let params: Dictionary<String, Any> = ["grant_type" : "refresh_token", "refresh_token" : refreshToken]
        let urlString = "https://securetoken.googleapis.com/v1/token?key=\(Config.apiKey)"
        super.init(urlString: urlString, parameters: params)
    }
    
}
