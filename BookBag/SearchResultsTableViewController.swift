//
//  SearchResultsTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/7/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

public let DismissSearchNotification = "DismissSearchNotificationName"
public let RestoreSearchNotification = "RestoreSearchNotificationName"
public let ResignSearchNotification = "ResignSearchNotificationName"

class SearchResultsTableViewController: UITableViewController {

    var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        restoreNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Set Up
    func setUpView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath) as! SearchResultsTableViewCell

        if let books = books {
            cell.updateWithBook(books[(indexPath as NSIndexPath).row])
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - TableViewDelegate 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        dismissNotification()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        resignNotification()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignNotification()
    }
    
    // MARK: - Notifications
    func dismissNotification() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: DismissSearchNotification), object: nil)
    }
    
    func resignNotification() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: ResignSearchNotification), object: nil)
    }
    
    func restoreNotification() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: RestoreSearchNotification), object: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let destinationVC = segue.destination as? BookDetailTableViewController {
           
            if let cell = sender as? SearchResultsTableViewCell, let indexPath = tableView.indexPath(for: cell), let books = books {
                destinationVC.book = books[(indexPath as NSIndexPath).row]
                if let image = cell.bookImage?.image {
                    destinationVC.loadedImage = image
                }
            }
        }
    }
    
}
