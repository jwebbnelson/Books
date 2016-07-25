//
//  HomeTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/26/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var bookArray: [Book]?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
    
        
        return cell
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
    
    @IBAction func profileButtonTapped(sender: AnyObject) {
   
        UserController.checkCurrentUser { (currentUser) in
            if currentUser == true {
                self.performSegueWithIdentifier("showProfileSegue", sender: nil)
            } else {
                self.performSegueWithIdentifier("showSignUpSegue", sender: nil)
            }
        }
    }
    
    
}

extension HomeTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        BookController.queryBooks(searchController.searchBar.text) { (book) in
            if let resultNav = searchController.searchResultsController as? UINavigationController, let resultsController = resultNav.viewControllers.first as? SearchResultsTableViewController {
                resultNav.popToRootViewControllerAnimated(true)
                if let books = book {
                    resultsController.books = books
                    dispatch_async(dispatch_get_main_queue(), {
                        resultsController.tableView.reloadData()
                    })
                } else {
                    self.bookArray = []
                }
            }
        }
    }
    
    func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("searchTVC")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.placeholder = "Search Books by Title..."
        searchController?.searchBar.autocapitalizationType = UITextAutocapitalizationType.Words
        tableView.tableHeaderView = searchController?.searchBar
        definesPresentationContext = true
        searchController?.searchBar.sizeToFit()
        listenForNotifications()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Notifications
extension HomeTableViewController {
    
    func listenForNotifications() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(HomeTableViewController.dismissSearch), name: DismissSearchNotification, object: nil)
        nc.addObserver(self, selector: #selector(HomeTableViewController.restoreSearch), name: RestoreSearchNotification, object: nil)
        nc.addObserver(self, selector: #selector(HomeTableViewController.resignSearch), name: ResignSearchNotification, object: nil)
    }
    
    func dismissSearch() {
        // searchController?.active = false
        searchController?.searchBar.hidden = true
        resignSearch()
    }
    
    func restoreSearch() {
        searchController?.searchBar.hidden = false
    }
    
    func resignSearch() {
        if searchController?.searchBar.isFirstResponder() == true {
            searchController?.searchBar.resignFirstResponder()
        }
    }
}




