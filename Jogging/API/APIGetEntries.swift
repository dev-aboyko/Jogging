//
//  APIGetEntries.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIGetEntries: RestAPIget {

    init(token: String) {
        let urlString = "\(Config.baseURL)/entries.json?auth=\(token)"
        super.init(urlString: urlString)
    }
    
    init(userId: String, token: String) {
        let user = "\"user\""
        let params = "auth=\(token)&orderBy=\(user)&equalTo=\"\(userId)\"".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "\(Config.baseURL)/entries.json?\(params)"
        super.init(urlString: urlString)
    }
    
}
