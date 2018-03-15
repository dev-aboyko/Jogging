//
//  AddEntryViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddEntryViewController: UITableViewController {

    @IBOutlet weak var userCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var distance: UITextField!

    private var editEntryKey: String?
    private var editEntry: JSON?
    private var editEmail: String?
    
    private var currentUser: (user: String, email: String)? {
        didSet {
            userCell.textLabel!.text = currentUser?.email ?? ""
        }
    }
    
    func editEntry(_ entry: JSON, key: String, email: String?) {
        editEntryKey = key
        editEntry = entry
        editEmail = email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editEntryKey != nil {
            guard let entry = editEntry else {
                Log.error("bad edit entry")
                return
            }
            self.title = "Edit entry"
            let timeInterval = TimeInterval(entry["date"].stringValue)!
            datePicker.date = Date(timeIntervalSince1970: timeInterval)
            let cal = Calendar.current
            var comp = DateComponents()
            comp.minute = Int(entry["minutes"].stringValue)
            timePicker.date = cal.date(from: comp)!
            distance.text = entry["distance"].stringValue
            if let email = editEmail {
                currentUser = (entry["user"].stringValue, email)
            } else {
                currentUser = UserData.currentUser
            }
        } else {
            currentUser = UserData.currentUser
        }
    }
    
    @IBAction func onDone(_ sender: Any) {
        if let entry = editEntryKey {
            updateEntry(entry)
        } else {
            addEntry()
        }
    }
    
    private func addEntry() {
        guard let intDistance = Int(distance.text!) else {
            Log.error("bad distance")
            return
        }
        API.addEntry(userId: currentUser!.user, date: datePicker.date, time: timePicker.date, distance: intDistance) { errorMessage in
            if errorMessage == nil {
                Log.message("Successfully added entry")
                self.dismiss(animated: true)
            } else {
                Log.error("adding entry. \(errorMessage!)")
            }
        }
    }
    
    private func updateEntry(_ entry: String) {
        guard let intDistance = Int(distance.text!) else {
            Log.error("bad distance")
            return
        }
        API.updateEntry(entry: entry, userId: currentUser!.user, date: datePicker.date, time: timePicker.date, distance: intDistance) { errorMessage in
            if errorMessage == nil {
                Log.message("Successfully updated entry")
                self.dismiss(animated: true)
            } else {
                Log.error("updating entry. \(errorMessage!)")
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select user" {
            let selectVC = segue.destination as! SelectUserViewController
            selectVC.onSelectUser = { self.currentUser = $0 }
        }
    }
    
    // MARK: - Show / Hide User section
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && !UserData.isAdmin {
            return 0
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !UserData.isAdmin {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
