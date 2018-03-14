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
        API.getEntries { (entries, errorMessage) in
            if let errorMessage = errorMessage {
                Log.error(errorMessage)
            } else if let entries = entries {
                self.entries = entries
                self.entryKeys = entries.map({ tuple -> String in
                    let (key, _) = tuple
                    return key
                })
                if let filter = self.filter {
                    let from = filter.from.timeIntervalSince1970
                    let to = filter.to.timeIntervalSince1970
                    Log.message("Filter \(from) \(to)")
                    self.entryKeys = self.entryKeys?.filter({ key -> Bool in
                        let date: TimeInterval = floor(entries[key]["date"].doubleValue)
                        Log.message("date: \(date)")
                        return from <= date && date <= to
                    })
                }
                self.tableView.reloadData()
            }
        }
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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryKeys?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: EntryCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EntryCell
        let entryKey = entryKeys![indexPath.row]
        let currentEntry = entries![entryKey]
        cell.configure(with: currentEntry)
        return cell
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
