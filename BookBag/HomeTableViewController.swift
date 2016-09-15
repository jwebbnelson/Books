//
//  HomeTableViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/26/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet var trendingSearchView: UIView!
    var bookArray: [Book]?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        setTableViewBackground()
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    
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
    
}

extension HomeTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        setTableViewBackground()
        
        BookController.queryBooks(searchController.searchBar.text) { (book) in
            if let resultNav = searchController.searchResultsController as? UINavigationController, let resultsController = resultNav.viewControllers.first as? SearchResultsTableViewController {
                resultNav.popToRootViewController(animated: true)
                if let books = book {
                    resultsController.books = books
                    DispatchQueue.main.async(execute: {
                        resultsController.tableView.reloadData()
                    })
                } else {
                    self.bookArray = []
                }
            }
        }
    }
    
    func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchTVC")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.placeholder = "Search Books by Title"
        searchController?.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController?.searchBar.backgroundColor = UIColor.white
        searchController?.searchBar.tintColor = UIColor.black
        searchController?.searchBar.autocapitalizationType = UITextAutocapitalizationType.words
        tableView.tableHeaderView = searchController?.searchBar
        definesPresentationContext = true
        searchController?.searchBar.sizeToFit()
        listenForNotifications()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func setTableViewBackground() {
        if let sc = searchController {
            if sc.isActive {
                tableView.backgroundView = nil
                tableView.isScrollEnabled = true
            } else {
                trendingSearchView.frame = tableView.frame
                tableView.backgroundView = trendingSearchView
                tableView.isScrollEnabled = false
            }
        }
    }
    
    @IBAction func trendingButtonTapped(_ sender: AnyObject) {
        searchController?.isActive = true
        if let sc = searchController {
        updateSearchResults(for: sc)
        }
        if let button = sender as? UIButton {
            searchController?.searchBar.text = button.titleLabel?.text
        }
        
    }
    
}

// MARK: - Notifications
extension HomeTableViewController {
    
    func listenForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(HomeTableViewController.dismissSearch), name: NSNotification.Name(rawValue: DismissSearchNotification), object: nil)
        nc.addObserver(self, selector: #selector(HomeTableViewController.restoreSearch), name: NSNotification.Name(rawValue: RestoreSearchNotification), object: nil)
        nc.addObserver(self, selector: #selector(HomeTableViewController.resignSearch), name: NSNotification.Name(rawValue: ResignSearchNotification), object: nil)
    }
    
    func dismissSearch() {
        // searchController?.active = false
        searchController?.searchBar.isHidden = true
        resignSearch()
    }
    
    func restoreSearch() {
        searchController?.searchBar.isHidden = false
    }
    
    func resignSearch() {
        if searchController?.searchBar.isFirstResponder == true {
            searchController?.searchBar.resignFirstResponder()
        }
    }
}




