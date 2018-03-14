//
//  EntriesViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 12/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import SwiftyJSON

class EntriesViewController: UITableViewController {

    private var entryKeys: [String]?
    private var userEntryKeys: Dictionary<String, [String]>?
    private var entries: JSON?
    private var filter: (from: Date, to: Date)?
    private var filterDescription: String {
        if let filter = self.filter {
            let from = filter.from.mediumString
            let to = filter.to.mediumString
            return "Filter: \(from) - \(to)"
        } else {
            return "Filter by dates"
        }
    }
    
    @IBOutlet private weak var filterButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterButton.setTitle(filterDescription, for: .normal)
        requestEntries()
    }
    
    private func requestEntries() {
        API.getEntries { (users, entries, errorMessage) in
            if let errorMessage = errorMessage {
                Log.error(errorMessage)
            } else if let entries = entries {
                self.entries = entries
                if let users = users {
                    self.userEntryKeys = self.makeUserEntryKeys(from: users, entries: entries)
                    self.entryKeys = nil
                } else {
                    self.entryKeys = self.makeEntryKeys(from: entries)
                    self.userEntryKeys = nil
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func makeEntryKeys(from entries: JSON) -> [String] {
        var entryKeys = entries.map({ tuple -> String in
            let (key, _) = tuple
            return key
        })
        if let filter = self.filter {
            let from = filter.from.timeIntervalSince1970
            let to = filter.to.timeIntervalSince1970
            Log.message("Filter \(from) \(to)")
            entryKeys = entryKeys.filter({ key -> Bool in
                let date: TimeInterval = floor(entries[key]["date"].doubleValue)
                Log.message("date: \(date)")
                return from <= date && date <= to
            })
        }
        return entryKeys
    }
    
    private func makeUserEntryKeys(from users: [String : String], entries: JSON) -> Dictionary<String, [String]> {
        Log.message("Users: \(users)")
        let entryKeys = makeEntryKeys(from: entries)
        var userEntryKeys = Dictionary<String, [String]>()
        entryKeys.forEach { item in
            guard let userId = entries[item]["user"].string else {
                Log.error("missing user ID for \(item)")
                return
            }
            guard let email = users[userId] else {
                Log.error("missing email for \(userId)")
                return
            }
            if var keys = userEntryKeys[email] {
                keys.append(item)
                userEntryKeys[email] = keys
            } else {
                userEntryKeys[email] = [item]
            }
        }
        return userEntryKeys
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.onSetFilter = { self.filter = $0 }
            filterVC.initialFilter = self.filter
        } else if segue.identifier == "Log out" {
            UserData.clear()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if userEntryKeys != nil {
            return userEntryKeys!.keys.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userEntryKeys != nil {
            let allUsers = Array(userEntryKeys!.keys)
            let user = allUsers[section]
            return userEntryKeys![user]!.count
        } else if entryKeys != nil {
            return entryKeys!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let userEntryKeys = userEntryKeys {
            let allUsers = Array(userEntryKeys.keys)
            return allUsers[section]
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: EntryCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EntryCell
        let currentEntry = entryAt(indexPath)
        cell.configure(with: currentEntry)
        return cell
    }
    
    private func entryAt(_ indexPath: IndexPath) -> JSON {
        if let userEntryKeys = userEntryKeys {
            let allUsers = Array(userEntryKeys.keys)
            let user = allUsers[indexPath.section]
            let entryKey = userEntryKeys[user]![indexPath.row]
            return entries![entryKey]
        } else {
            let entryKey = entryKeys![indexPath.row]
            return entries![entryKey]
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Log.message("Delete row \(indexPath.row)")
            API.deleteEntry(name: entryKeys![indexPath.row], completion: { errorMessage in
                guard errorMessage == nil else {
                    // insert message UI
                    return
                }
                self.entryKeys?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
