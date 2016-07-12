//
//  SellTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit
import CoreLocation

enum SellTextFields: String {
    case Title = "Name of Textbook"
    case Author = "John, Smith"
    case Edition = "Version #"
    case Location = "Zipcode"
    case Price = "$$$"
}

class SellTableViewController: UITableViewController {

    
    let labelArray = ["Title", "Author", "Edition", "Location", "Price"]
    let promptArray = ["Name of Textbook", "John, Smith", "Version #", "Zipcode", "$$$"]
    var isbn: String?
    var author: String?
    var edition: String?
    var location: CLLocation?
    var price: Double?
    var notes: String?
    var image: UIImage?
    
    @IBOutlet weak var tableHeadView: UIView!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet var notesView: UIView!
    let notesBackground = UIView()
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableHeadView.frame.size.height = view.frame.size.height/7
        setUpNotesView()
        listenForNotifications()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 7
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("extraCell", forIndexPath: indexPath) as! ExtraSellTableViewCell
            cell.delegate = self
            return cell

        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("nextCell", forIndexPath: indexPath) as! NextTableViewCell
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath) as! BasicSellTableViewCell
            
            cell.setDetails(labelArray[indexPath.row], prompt: promptArray[indexPath.row])
            cell.entryTextField.delegate = self
            
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

    // MARK: - Notifications
    func listenForNotifications() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(SellTableViewController.updateISBN(_:)), name: ISBNUpdatedNotification, object: nil)
    }
    
    func updateISBN(notification:NSNotification) {
        if let isbnString = notification.object as? String {
            isbn = isbnString
            dispatch_async(dispatch_get_main_queue(), {
                self.isbnTextField.text = isbnString
            })
        }
    }
    
}

extension SellTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
      
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            textField.keyboardType = UIKeyboardType.Default
        case SellTextFields.Author.rawValue:
            textField.keyboardType = UIKeyboardType.Default
        case SellTextFields.Edition.rawValue:
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        case SellTextFields.Location.rawValue:
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        case SellTextFields.Price.rawValue:
            price = NSNumberFormatter().numberFromString(textField.text ?? "")?.doubleValue
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        default:
            return
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            setNextResponder(1)
        case SellTextFields.Author.rawValue:
            setNextResponder(2)
        case SellTextFields.Edition.rawValue:
            setNextResponder(3)
        case SellTextFields.Location.rawValue:
            setNextResponder(4)
        case SellTextFields.Price.rawValue:
            textField.resignFirstResponder()
        default:
            return true
        }
        return true
    }
    
    func setNextResponder(nextRow:Int) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: nextRow, inSection: 0)) as? BasicSellTableViewCell
        cell?.entryTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            title = textField.text
        case SellTextFields.Author.rawValue:
            author = textField.text
        case SellTextFields.Edition.rawValue:
            edition = textField.text
        case SellTextFields.Location.rawValue:
            if textField.text?.characters.count == 5 {
                LocationController.convertStringToLocation(textField.text ?? "", completion: { (placemark) in
                    if let location = placemark?.locality, let state = placemark?.administrativeArea {
                        self.location = placemark?.location
                        dispatch_async(dispatch_get_main_queue(), {
                            UIView.animateWithDuration(2, animations: {
                                textField.text = "\(location), \(state)"
                                textField.textColor = UIColor.blackColor()
                            })
                        })
                    }
                })
            } else {
                textField.textColor = UIColor.redColor()
            }
        case SellTextFields.Price.rawValue:
            price = NSNumberFormatter().numberFromString(textField.text ?? "")?.doubleValue
            if var text = textField.text {
                text = text.stringByReplacingOccurrencesOfString("$", withString: "")
                textField.text = "$\(text)"
            }
        default:
            return
        }
        
    }
}

extension SellTableViewController: SellButtonDelegate {
    func sellButtonTapped() {
        view.endEditing(true)
        
        if let title = title, let author = author, price = price, let isbn = isbn {
            BookController.submitTextbookForApproval(author, title: title, isbn: isbn, edition: edition, price: price ?? 0, notes: notes) { (error) in
                if let error = error {
                    print(error.description)
                } else {
                    print("TEXTBOOK SAVED")
                }
            }
            performSegueWithIdentifier("SellReviewSegue", sender: nil)
        }
    }
}

extension SellTableViewController: ExtraButtonsDelgate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func photosPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Add Photo", message: "Take a picture of your textbook", preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image = image
    }
    
    func notesPressed() {
        presentNotesView()
    }
}

extension SellTableViewController {
    
    func setUpNotesView() {
        notesView.frame.size.height = view.frame.size.height/3
        notesView.frame.size.width = view.frame.size.width - 20
        notesView.center.x = view.center.x
        notesView.center.y = view.center.y - (view.frame.height * 0.35) + (navigationController?.navigationBar.frame.height)!
        resetNotesAnimation()
    }
    
    func presentNotesView() {
        notesBackground.frame = view.frame
        notesBackground.backgroundColor = UIColor.blackColor()
        notesBackground.alpha = 0.4
        view.addSubview(notesBackground)
        view.addSubview(notesView)
        UIView.animateWithDuration(0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.notesView.transform = CGAffineTransformIdentity
            self.notesView.alpha = 1
        }) { (success) in
            
        }
    }
    
    func dismissNotesView() {
        notesBackground.removeFromSuperview()
        notesView.removeFromSuperview()
        resetNotesAnimation()
        notesTextView.resignFirstResponder()
    }
    
    func resetNotesAnimation() {
        notesView.transform = CGAffineTransformMakeScale(0, 0)
        notesView.alpha = 0
    }
    
    @IBAction func saveNotes(sender: AnyObject) {
        notes = notesTextView.text
        dismissNotesView()
    }
    
    @IBAction func cancelNotes(sender: AnyObject) {
        dismissNotesView()
    }
}

extension SellTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter notes here..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text != "Enter notes here..." {
            notes = notesTextView.text
        }
    }
}








