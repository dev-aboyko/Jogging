//
//  AddEntryViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class AddEntryViewController: UITableViewController {

    @IBOutlet weak var userCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var distance: UITextField!
    
    private var currentUser: (user: String, email: String)? {didSet { userCell.textLabel!.text = currentUser?.email ?? "" } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserData.currentUser
    }
    
    @IBAction func addEntry(_ sender: Any) {
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
