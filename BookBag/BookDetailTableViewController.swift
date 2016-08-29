//
//  BookDetailTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/7/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class BookDetailTableViewController: UITableViewController {

    @IBOutlet weak var tableViewHeaderView: UIView!
    var book: Book?
    var loadedImage: UIImage?
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet var expandedView: ExpandedView!
    @IBOutlet var bidView: BidView!
    
    var darkView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewSize()
        loadImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage() {
        if let image = loadedImage {
            bookImageView.image = image
        } else if let book = book, let imageURL = NSURL(string: book.image) {
            ImageController.fetchImageAtURL(imageURL, completion: { (image, error) in
                guard let image = image else {
                    print("FAILURE LOADING IMAGE: \(error?.description)")
                    return
                }
                self.loadedImage = image
                dispatch_async(dispatch_get_main_queue(), {
                    self.bookImageView.image = image
                })
            })
        }
        configureGesture()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let book = self.book, let _ = book.notes {
            return 5
        } else {
            return 4
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let book = book {
            // 5 CELLS
            if let _ = book.notes {
                if indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("bookHighlightCell", forIndexPath: indexPath) as! BookHighlightTableViewCell
                    cell.updateCell(book)
                    return cell
                }
                
            } else { // 4 CELLS
                if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("bookHighlightCell", forIndexPath: indexPath) as! BookHighlightTableViewCell
                    cell.updateCell(book)
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("bookDetailCell", forIndexPath: indexPath) as! BookDetailTableViewCell
            cell.updateCellWithBook(book, row: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Details"
    }
    
    // MARK: TableView Heights
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setTableViewSize() {
        tableViewHeaderView.frame.size.height = tableView.frame.size.height/3
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: - BarButtonActions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - BIDVIEW
    
    @IBAction func bidButtonTapped(sender: AnyObject) {
        if let book = book {
            bidView.configure(book)
        }
        bidView.frame.size.width = tableView.frame.width * 0.75
        bidView.frame.size.height = 250
        bidView.center.y = tableView.center.y - tableView.frame.size.height/4.5
        bidView.center.x = tableView.center.x
        darkView = UIView(frame: tableView.frame)
        darkView?.backgroundColor = UIColor.blackColor()
        darkView?.alpha = 0.0
        bidView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -tableView.frame.size.height, 0)
        view.addSubview(darkView!)
        view.addSubview(bidView)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.bidView.layer.transform = CATransform3DIdentity
            self.darkView?.alpha = 0.3
            }, completion: nil)
        
    }
    
    @IBAction func confirmBidTapped(sender: AnyObject) {
        view.endEditing(true)
        if let book = book {
            if let price = NSNumberFormatter().numberFromString(bidView.offerTextField.text ?? "")?.doubleValue {
                BookController.bidForBook(book.ownerID, price: price, book: book, completion: { (bid) in
                    guard bid != nil else {
                        print("Failure to create bid")
                        return
                    }
                    self.dismissBidView()
                })
            }
            
        }
    }
    
    @IBAction func cancelBidTapped(sender: AnyObject) {
        view.endEditing(true)
        
        dismissBidView()
    }
    
    
    func dismissBidView() {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                self.bidView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -self.tableView.frame.size.height, 0)
                self.darkView?.alpha = 0
            }) { (success) in
                self.darkView?.removeFromSuperview()
                self.bidView.removeFromSuperview()
            }
        }
    }
    
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
   
    }
    
    // MARK: - Photo Enlarge
    func configureGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BookDetailTableViewController.enlargePhoto))
        bookImageView.addGestureRecognizer(gestureRecognizer)
        bookImageView.userInteractionEnabled = true
        configureExpandedView()
    }
    
    func configureExpandedView() {
        expandedView.cancelButton.addTarget(self, action: #selector(BookDetailTableViewController.dismissPhoto), forControlEvents: .TouchUpInside)
        expandedView.frame = bookImageView.frame
        expandedView.layer.transform = CATransform3DMakeScale(0, 0, 0)
    }
    
    func enlargePhoto() {
        expandedView.imageView.image = loadedImage
        view.addSubview(expandedView)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.expandedView.frame = self.view.frame
            self.expandedView.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
    
    func dismissPhoto() {
        expandedView.removeFromSuperview()
        self.expandedView.frame = self.bookImageView.frame
        self.expandedView.layer.transform = CATransform3DMakeScale(0, 0, 0)
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

// MARK: - TEXTFIELD

extension BookDetailTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        bidView.confirmButton.setTitleColor(UIColor.actionGreen(), forState: .Normal)
    }
    
    
    
    
}


