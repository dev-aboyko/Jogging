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
    
    static func weekIndexFrom(timeInterval: TimeInterval) -> Int {
        var comp = DateComponents()
        comp.day = 1
        comp.month = 1
        comp.year = 1973
        
        let cal = Calendar.current
        let monday_01_01_73 = cal.date(from: comp)!
        let date = Date(timeIntervalSince1970: timeInterval)
        comp = cal.dateComponents([.day], from: monday_01_01_73, to: date)
        let weeks = comp.day! / 7
        return weeks
    }
    
}
