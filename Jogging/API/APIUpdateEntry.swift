//
//  APIUpdateEntry.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class APIUpdateEntry: RestAPIput {

    init(entry: String, date: TimeInterval, minutes: Int, distance: Int, userId: String, token: String) {
        let urlString = "\(Config.baseURL)/entries/\(entry).json?auth=\(token)"
        let entry: Dictionary<String, Any> = ["date" : date, "minutes" : minutes, "distance" : distance, "user" : userId]
        super.init(urlString: urlString, parameters: entry)
    }
    
}
