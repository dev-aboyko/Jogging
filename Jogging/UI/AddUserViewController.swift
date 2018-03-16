//
//  AddUserViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class AddUserViewController: UITableViewController {

    @IBOutlet weak var roleControl: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    private var role: String {
        switch roleControl.selectedSegmentIndex {
        case 1: return "umanager"
        case 2: return "admin"
        default: return "user"
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onDone(_ sender: Any) {
        API.createUser(email: email.text!, password: password.text!, role: role) { errorMessage in
            guard errorMessage == nil else {
                self.showAlert(message: errorMessage!)
                return
            }
            self.dismiss(animated: true)
        }
    }

}
