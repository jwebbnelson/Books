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
    case Title = "Title"
    case Author = "John, Smith"
    case Edition = "Version #"
    // FORMAT - 3
    case Location = "Zipcode" // 4
    case Price = "$$$" // 5
    // EXTRA - 6
    // NEXT - 7
}

enum SellTableViewCells: Int {
    case Title, Author, Edition, Format,
    Location, Price, Extra, Next
}

public let SellDismissedNotification = "SellDismissedNotificationName"

class SellTableViewController: UITableViewController {

    let labelArray = ["TITLE", "AUTHOR", "EDITION", "", "LOCATION", "PRICE"]
    let promptArray = ["Title", "John, Smith", "Version #", "", "Zipcode", "$$$"]
    var isbn: String?
    var bookTitle: String?
    var author: String?
    var edition: String?
    var location: CLLocation?
    var price: Double?
    var notes: String?
    var image: UIImage?
    var formatString: String?
    
    @IBOutlet weak var tableHeadView: UIView!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet var notesView: UIView!
    let notesBackground = UIView()
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var loadingView: LoadingView!
    var backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableHeadView.frame.size.height = view.frame.size.height/9
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
        return 8
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case SellTableViewCells.Format.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier("formatCell", forIndexPath: indexPath) as! FormatTableViewCell
            cell.delegate = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("extraCell", forIndexPath: indexPath) as! ExtraSellTableViewCell
            cell.delegate = self
            return cell
        case 7:
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
        switch indexPath.row {
        case 3:
            return 32
        case 7:
            return 48
        default:
            return (view.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - tableHeadView.frame.size.height)/7
        }
    }
    
    // MARK: - TableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
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

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(SellDismissedNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationVC = segue.destinationViewController as? BookDetailTableViewController, let book = sender as? Book {
            
            destinationVC.book = book
            if let image = image {
                destinationVC.loadedImage = image
            }
        }
    }
    
    
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

// MARK: - TextField Delegate
extension SellTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == textField.placeholder {
            textField.text = ""
            textField.textColor = UIColor.blackColor()
        }
        
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            textField.keyboardType = UIKeyboardType.Default
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            showCellLabel(SellTableViewCells.Title.rawValue)
        case SellTextFields.Author.rawValue:
            textField.keyboardType = UIKeyboardType.Default
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            showCellLabel(SellTableViewCells.Author.rawValue)
        case SellTextFields.Edition.rawValue:
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            showCellLabel(SellTableViewCells.Edition.rawValue)
        case SellTextFields.Location.rawValue:
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            showCellLabel(SellTableViewCells.Location.rawValue)
        case SellTextFields.Price.rawValue:
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            showCellLabel(SellTableViewCells.Price.rawValue)
        default:
            return
        }
    }
    
    func showCellLabel(row:Int) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? BasicSellTableViewCell {
            dispatch_async(dispatch_get_main_queue(), {
                cell.detailLabel.hidden = false
            })
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            setNextResponder(1)
        case SellTextFields.Author.rawValue:
            setNextResponder(2)
        case SellTextFields.Edition.rawValue:
            setNextResponder(4)
        case SellTextFields.Location.rawValue:
            setNextResponder(5)
        case SellTextFields.Price.rawValue:
            textField.resignFirstResponder()
            performSelector(#selector(scrollToNextButton), withObject: nil, afterDelay: 0.3)
        default:
            return true
        }
        return true
    }
    
    func scrollToNextButton() {
         tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func setNextResponder(nextRow:Int) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: nextRow, inSection: 0)) as? BasicSellTableViewCell
        cell?.entryTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            bookTitle = textField.text
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
            if isbnTextField.text != "" {
                isbn = isbnTextField.text
            }
            return
        }
        
    }
}

// MARK: - SellButtonDelegate
extension SellTableViewController: SellButtonDelegate {
    func sellButtonTapped() {
        view.endEditing(true)
        
        if let bookTitle = bookTitle, let author = author, price = price, let isbn = isbn, let formatString = formatString {
            beginLoadingView()
            loadingView.updateLabel("Confirming Book Details")
            BookController.submitTextbookForApproval(author, title: bookTitle, isbn: isbn, edition: edition, price: price ?? 0, notes: notes, format: formatString) { (book, bookID, error) in
                if let error = error {
                    print(error)
                } else {
                    print("TEXTBOOK SAVED")
                    if let image = self.image, let bookID = bookID {
                        self.loadingView.updateLabel("Saving Textbook")
                        BookController.uploadPhotoToFirebase(bookID, image: image, completion: { (fileURL, error) in
                            guard let url = fileURL else {
                                print(error?.localizedDescription)
                                self.loadingView.label.text = error?.localizedDescription
                                self.dismissLoadingView()
                                return
                            }
                            BookController.updateBookPath(bookID, imagePath: url)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.dismissLoadingView()
                                if let book = book {
                                    self.performSegueWithIdentifier("SellReviewSegue", sender: book)
                                }
                            })
                        })
                    } else {
                        self.dismissLoadingView()
                    }
                }
            }
        } else {
            checkRequiredFields()
        }
    }
    
    func checkRequiredFields() {
        for cell in tableView.visibleCells {
            if let indexPath = tableView.indexPathForCell(cell), let textCell = tableView.cellForRowAtIndexPath(indexPath) as? BasicSellTableViewCell {
                textCell.updateForError()
            }
        }
        guard isbn != nil else {
            isbnTextField.textColor = UIColor.redColor()
            isbnTextField.text = isbnTextField.placeholder
            return
        }
        
        if isbn?.characters.count != 10 || isbn?.characters.count != 13 {
            // WARNING - Error
        }
    }
    
    // MARK: - LoadingView
    func beginLoadingView() {
        backgroundView = UIView(frame: self.tableView.frame)
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0.4
        view.addSubview(backgroundView)
        loadingView.center.y = view.center.y
        loadingView.center.x = view.center.x
        view.addSubview(loadingView)
        loadingView.activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        loadingView.activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
}

// MARK: - ExtraButtonsDelegate, ImagePicker
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
        
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: SellTableViewCells.Extra.rawValue, inSection: 0)) as? ExtraSellTableViewCell {
            dispatch_async(dispatch_get_main_queue(), {
                cell.photoButton.imageView?.image = UIImage(named: "PhotoMinimalComplete")
            })
            
        }
    }
    
    func notesPressed() {
        presentNotesView()
    }
}

// MARK: - FormatCellDelegat
extension SellTableViewController: FormatCellDelegate {
    
    func formatSelected(format: Int) {
        switch format {
        case 0:
            formatString = "Paperback"
        default:
            formatString = "Hardcover"
        }
    }
}

// MARK: - NotesView
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
        
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: SellTableViewCells.Extra.rawValue, inSection: 0)) as? ExtraSellTableViewCell {
            dispatch_async(dispatch_get_main_queue(), {
                cell.notesButton.imageView?.image = UIImage(named: "NotesComplete")
            })
            
        }

    }
    
    @IBAction func cancelNotes(sender: AnyObject) {
        dismissNotesView()
    }
}

// MARK: - TextView Delegate
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








