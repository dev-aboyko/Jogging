//
//  ReportViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 16/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReportViewController: UITableViewController {

    private var weekKeys = [Int]()
    private var weeks = Dictionary<Int, [JSON]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestEntries()
    }

    private func requestEntries() {
        API.getMyEntries { entries, errorMessage in
            guard errorMessage == nil else {
                self.showAlert(message: errorMessage)
                return
            }
            guard let entries = entries else {
                return
            }
            var weeks = Dictionary<Int, [JSON]>()
            for (_, json) in entries {
                guard let timeInterval: TimeInterval = json["date"].double else {
                    Log.error("getting time interval")
                    continue
                }
                let weekId = Date.weekIndexFrom(timeInterval: timeInterval)
                if let _ = weeks[weekId] {
                    weeks[weekId]?.append(json)
                } else {
                    weeks[weekId] = [json]
                }
            }
            self.weeks = weeks
            self.weekKeys = weeks.keys.sorted { $0 > $1}
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Week cell", for: indexPath)

        let firstWeek = weekKeys.min()!
        let key = weekKeys[indexPath.row]
        let array = weeks[key]!
        
        let values = array.reduce((Int(0), Int(0)), { (v, json) -> (Int, Int) in
            let distance = Int(json["distance"].stringValue)!
            let minutes = Int(json["minutes"].stringValue)!
            return (v.0 + distance, v.1 + minutes)
        })
        let weekNr = key - firstWeek + 1
        let speed = values.1 == 0 ? "unknown" : String(format: "%.2f km/h", Double(values.0) / Double(values.1) * 0.06)
        cell.textLabel?.text? = "Week \(weekNr): \(values.0) meters"
        cell.detailTextLabel?.text? = "at \(speed)"
        
        return cell
    }

}
