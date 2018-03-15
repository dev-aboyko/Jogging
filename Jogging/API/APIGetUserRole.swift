//
//  APIGetUserRole.swift
//  Jogging
//
//  Created by Alexey Boyko on 11/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class APIGetUserRole: RestAPIget {

    var userRole: String? { return json?["role"].string }
    var email: String? { return json?["email"].string }
    
    init(userId: String, token: String) {
        let urlString = "\(Config.baseURL)/users/\(userId).json?auth=\(token)"
        super.init(urlString: urlString)
    }
    
}
