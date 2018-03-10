//
//  Config.swift
//  Jogging
//
//  Created by Alexey Boyko on 10/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class Config {
    
    static var apiKey: String {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        guard let result = myDict?.object(forKey: "API_KEY") as? String else {
            Log.error("Error reading API_KEY from GoogleService-Info.plist")
            return ""
        }
        return result
    }
    
}
