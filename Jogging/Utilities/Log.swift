//
//  Log.swift
//  Jogging
//
//  Created by Alexey Boyko on 07/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class Log {
    
    static func message(_ str: String) {
        print(str)
    }
    
    static func error(_ str: String) {
        message("Error \(str)")
    }
    
}
