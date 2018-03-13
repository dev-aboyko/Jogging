//
//  APIAddEntry.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class APIAddEntry: RestAPIpost {

    init(date: TimeInterval, minutes: Int, distance: Int, userId: String, token: String) {
        let urlString = "\(Config.baseURL)/entries.json?auth=\(token)"
        let entry: Dictionary<String, Any> = ["date" : date, "minutes" : minutes, "distance" : distance, "user" : userId]
        super.init(urlString: urlString, parameters: entry)
    }
    
}
