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
    case title, author, edition, format,
    location, price, extra, next
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
    @IBOutlet var notesView: NotesView!
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row {
        case SellTableViewCells.format.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "formatCell", for: indexPath) as! FormatTableViewCell
            cell.delegate = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraCell", for: indexPath) as! ExtraSellTableViewCell
            cell.delegate = self
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nextCell", for: indexPath) as! NextTableViewCell
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! BasicSellTableViewCell
            cell.setDetails(labelArray[(indexPath as NSIndexPath).row], prompt: promptArray[(indexPath as NSIndexPath).row])
            cell.entryTextField.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).row {
        case 3:
            return 40
        case 7:
            return 48
        default:
            return (view.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - tableHeadView.frame.size.height)/7
        }
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: SellDismissedNotification), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationVC = segue.destination as? BookDetailTableViewController, let book = sender as? Book {
            
            destinationVC.book = book
            if let image = image {
                destinationVC.loadedImage = image
            }
        }
    }
    
    
    // MARK: - Notifications
    func listenForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(SellTableViewController.updateISBN(_:)), name: NSNotification.Name(rawValue: ISBNUpdatedNotification), object: nil)
    }
    
    func updateISBN(_ notification:Notification) {
        if let isbnString = notification.object as? String {
            isbn = isbnString
            DispatchQueue.main.async(execute: {
                self.isbnTextField.text = isbnString
            })
        }
    }
}

// MARK: - TextField Delegate
extension SellTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == textField.placeholder {
            textField.text = ""
            textField.textColor = UIColor.black
        }
        
        switch  textField.placeholder! {
        case SellTextFields.Title.rawValue:
            textField.keyboardType = UIKeyboardType.default
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            showCellLabel(SellTableViewCells.title.rawValue)
        case SellTextFields.Author.rawValue:
            textField.keyboardType = UIKeyboardType.default
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            showCellLabel(SellTableViewCells.author.rawValue)
        case SellTextFields.Edition.rawValue:
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
            showCellLabel(SellTableViewCells.edition.rawValue)
        case SellTextFields.Location.rawValue:
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
            showCellLabel(SellTableViewCells.location.rawValue)
        case SellTextFields.Price.rawValue:
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
            showCellLabel(SellTableViewCells.price.rawValue)
        default:
            return
        }
    }
    
    func showCellLabel(_ row:Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BasicSellTableViewCell {
            DispatchQueue.main.async(execute: {
//                cell.detailLabel.isHidden = false
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
            perform(#selector(scrollToNextButton), with: nil, afterDelay: 0.3)
        default:
            return true
        }
        return true
    }
    
    func scrollToNextButton() {
         tableView.scrollToRow(at: IndexPath(row: 6, section: 0), at: .bottom, animated: true)
    }
    
    func setNextResponder(_ nextRow:Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: nextRow, section: 0)) as? BasicSellTableViewCell
        cell?.entryTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
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
                        DispatchQueue.main.async(execute: {
                            UIView.animate(withDuration: 2, animations: {
                                textField.text = "\(location), \(state)"
                                textField.textColor = UIColor.black
                            })
                        })
                    }
                })
            } else {
                textField.textColor = UIColor.red
            }
        case SellTextFields.Price.rawValue:
            price = NumberFormatter().number(from: textField.text ?? "")?.doubleValue
            if var text = textField.text {
                text = text.replacingOccurrences(of: "$", with: "")
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
   
    @IBAction func saveTapped(_ sender: AnyObject) {
        sellButtonTapped()
    }
    
    
    func sellButtonTapped() {
        view.endEditing(true)
        
        guard image != nil else {
            checkRequiredFields()
            showErrorLabel("Please enter an image to show your book")
            return
        }
        
        if let bookTitle = bookTitle, let author = author, let price = price, let isbn = isbn, let formatString = formatString {
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
                            DispatchQueue.main.async(execute: {
                                self.dismissLoadingView()
                                if let book = book {
                                    self.performSegue(withIdentifier: "SellReviewSegue", sender: book)
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
            if let indexPath = tableView.indexPath(for: cell), let textCell = tableView.cellForRow(at: indexPath) as? BasicSellTableViewCell {
                textCell.updateForError()
            }
        }
        guard isbn != nil else {
            isbnTextField.textColor = UIColor.red
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
        backgroundView.backgroundColor = UIColor.black
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
        
        let alert = UIAlertController(title: "Add Photo", message: "Take a picture of your textbook", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image = image
        
        if let cell = tableView.cellForRow(at: IndexPath(row: SellTableViewCells.extra.rawValue, section: 0)) as? ExtraSellTableViewCell {
            DispatchQueue.main.async(execute: {
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
    
    func formatSelected(_ format: Int) {
        switch format {
        case BookFormat.paperback.rawValue:
            formatString = "Paperback"
        case BookFormat.hardcover.rawValue:
            formatString = "Hardcover"
        default:
            formatString = nil
        }
    }
}

// MARK: - NotesView
extension SellTableViewController {
    
    func setUpNotesView() {
        notesView.frame.size.height = view.frame.size.height/3
        notesView.frame.size.width = view.frame.size.width * 0.8
        notesView.center.x = view.center.x
        notesView.center.y = view.center.y - (view.frame.height * 0.35) + (navigationController?.navigationBar.frame.height)!
        resetNotesAnimation()
    }
    
    func presentNotesView() {
        notesView.setUp()
        notesBackground.frame = view.frame
        notesBackground.backgroundColor = UIColor.black
        notesBackground.alpha = 0.3
        view.addSubview(notesBackground)
        view.addSubview(notesView)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.notesView.transform = CGAffineTransform.identity
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
        notesView.transform = CGAffineTransform(scaleX: 0, y: 0)
        notesView.alpha = 0
    }
    
    @IBAction func saveNotes(_ sender: AnyObject) {
        notes = notesTextView.text
        dismissNotesView()
        
        if let cell = tableView.cellForRow(at: IndexPath(row: SellTableViewCells.extra.rawValue, section: 0)) as? ExtraSellTableViewCell {
            DispatchQueue.main.async(execute: {
                cell.notesButton.imageView?.image = UIImage(named: "NotesComplete")
            })
            
        }

    }
    
    @IBAction func cancelNotes(_ sender: AnyObject) {
        dismissNotesView()
    }
}

// MARK: - TextView Delegate
extension SellTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter notes here..." {
            textView.text = ""
        }
        notesView.makeSaveable()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "Enter notes here..." {
            notes = notesTextView.text
        }
    }
}
// MARK: - Error Handling
extension SellTableViewController {
    func showErrorLabel(_ errorString:String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}








