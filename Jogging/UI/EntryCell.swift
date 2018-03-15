//
//  EntryCell.swift
//  Jogging
//
//  Created by Alexey Boyko on 13/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class EntryCell: UITableViewCell {

    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var speed: UILabel!
    
    func configure(with entry: JSON) {
        let timeInterval = TimeInterval(entry["date"].stringValue)!
        let date = Date(timeIntervalSince1970: timeInterval)
        self.date.text = date.mediumString
        let minutes = Int(entry["minutes"].stringValue)!
        let distance = Int(entry["distance"].stringValue)!
        self.time.text = "\(minutes) minutes"
        self.distance.text = "\(distance) meters"
        if minutes != 0 {
            let speed = Double(distance) / Double(minutes) * 0.06
            self.speed.text = String(format: "Average speed: %.2f km/h", speed)
        } else {
            speed.text = "Average speed unavailalbe"
        }
    }
    
}
