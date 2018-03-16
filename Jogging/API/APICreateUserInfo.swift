//
//  APICreateUserInfo.swift
//  Jogging
//
//  Created by Alexey Boyko on 16/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class APICreateUserInfo: RestAPIput {
    
    init(userId: String, email: String, role: String, token: String) {
        let urlString = "\(Config.baseURL)/users/\(userId).json?auth=\(token)"
        let userInfo: Dictionary<String, Any> = ["email" : email, "role": role]
        super.init(urlString: urlString, parameters: userInfo)
    }
    
}
