//
//  FilterViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 14/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    var onSetFilter: (( (from: Date, to: Date)? ) -> Void)?
    var initialFilter: (from: Date, to: Date)?
    
    @IBOutlet private weak var fromDate: UIDatePicker!
    @IBOutlet weak var toDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let initialFilter = initialFilter {
            fromDate.date = initialFilter.from
            toDate.date = initialFilter.to
        }
    }
    
    @IBAction func clearFilter(_ sender: Any) {
        onSetFilter?(nil)
        navigationController?.popViewController(animated: true)
    }
 
    @IBAction func setFilter(_ sender: Any) {
        let cal = Calendar.current
        var minDate = min(fromDate!.date, toDate!.date)
        var maxDate = max(fromDate!.date, toDate!.date)
        var minComp = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: minDate)
        minComp.hour = 0
        minComp.minute = 0
        minComp.second = 0
        var maxComp = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: maxDate)
        maxComp.hour = 23
        maxComp.minute = 59
        maxComp.second = 59
        minDate = cal.date(from: minComp)!
        maxDate = cal.date(from: maxComp)!
        let dates = (minDate, maxDate)
        onSetFilter?(dates)
    }
    
}
