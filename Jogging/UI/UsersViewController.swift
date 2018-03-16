//
//  UsersViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsersViewController: UITableViewController {

    private var userKeys: [String]?
    private var users: JSON?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUsers()
    }

    private func requestUsers() {
        API.getUsers { (users, errorMessage) in
            if let errorMessage = errorMessage {
                self.showAlert(message: errorMessage)
            } else {
                self.userKeys = users?.map { $0.0 }
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userKeys?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User cell", for: indexPath)
        let key = userKeys![indexPath.row]
        let user = users![key]
        cell.textLabel?.text = user["email"].string
        cell.detailTextLabel?.text = user["role"].string
        return cell
    }

}
