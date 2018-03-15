//
//  APIGetUsers.swift
//  Jogging
//
//  Created by Alexey Boyko on 14/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class APIGetUsers: RestAPIget {

    init(token: String) {
        let urlString = "\(Config.baseURL)/users.json?auth=\(token)"
        super.init(urlString: urlString)
    }
    
}
