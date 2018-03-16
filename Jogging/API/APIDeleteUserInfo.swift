//
//  APIDeleteUserInfo.swift
//  Jogging
//
//  Created by Alexey Boyko on 16/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class APIDeleteUserInfo: RestAPIdelete {
    
    init(userId: String, token: String) {
        let urlString = "\(Config.baseURL)/users/\(userId).json?auth=\(token)"
        super.init(urlString: urlString)
    }
    
}
