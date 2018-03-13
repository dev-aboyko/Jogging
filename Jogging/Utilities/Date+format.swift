//
//  Date+format.swift
//  Jogging
//
//  Created by Alexey Boyko on 13/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

extension Date {
    
    var mediumString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
}
