//
//  SellTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit
import CoreLocation

class SellTableViewController: UITableViewController {

    
    let labelArray = ["Title", "Author", "Edition", "Location", "Price"]
    let promptArray = ["Name of Textbook", "John, Smith", "Version #", "Zipcode", "$$$"]
    var isbn: String?
    var author: String?
    var edition: String?
    var location: CLLocation?
    var price: Double?
    
    @IBOutlet weak var tableHeadView: UIView!
    var nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableHeadView.frame.size.height = view.frame.size.height/7

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override var inputAccessoryView: UIView {
        return nextButton
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row != 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath) as! BasicSellTableViewCell
            
            cell.setDetails(labelArray[indexPath.row], prompt: promptArray[indexPath.row])
            cell.entryTextField.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("extraCell", forIndexPath: indexPath) as! ExtraSellTableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (view.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - tableHeadView.frame.size.height)/8
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SellTableViewController: UITextFieldDelegate {
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.placeholder == "Zipcode" {
            LocationController.convertStringToLocation(textField.text ?? "", completion: { (placemark) in
                if let location = placemark?.locality, let state = placemark?.administrativeArea {
                    dispatch_async(dispatch_get_main_queue(), {
                        textField.text = "\(location), \(state)"
                    })
                }
            })
        }
    }
    
    
    
}








