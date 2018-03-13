//
//  AddEntryViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class AddEntryViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var distance: UITextField!
    
    @IBAction func addEntry(_ sender: Any) {

        guard let intDistance = Int(distance.text!) else {
            Log.error("bad distance")
            return
        }
        API.addEntry(date: datePicker.date, time: timePicker.date, distance: intDistance) { errorMessage in
            if errorMessage == nil {
                Log.message("Successfully added entry")
                self.dismiss(animated: true)
            } else {
                Log.error("adding entry. \(errorMessage!)")
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
