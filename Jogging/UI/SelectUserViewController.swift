//
//  SelectUserViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectUserViewController: UITableViewController {

    var onSelectUser: (((user: String, email: String)) -> Void)?
    private var users: [(user: String, email: String)]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API.getUsers { users, errorMessage in
            if let errorMessage = errorMessage {
                Log.error(errorMessage)
            } else {
                self.users = users!.map { (user: $0.0, email: $0.1["email"].stringValue) }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic user cell", for: indexPath)
        let user = users![indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users![indexPath.row]
        onSelectUser?(user)
        navigationController?.popViewController(animated: true)
    }
    
}
