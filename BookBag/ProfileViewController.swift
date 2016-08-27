//
//  ProfileViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/20/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum ProfileState {
    case Buy, Sell, LoggedOut
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    var currentViewState: ProfileState {
        get {
            if let _ = UserController.sharedController.currentUser {
                return .Buy
            } else {
                return .LoggedOut
            }
        }
        
        set {
           configureTab(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
  
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        adjustViewForLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? BookDetailTableViewController, let books = UserController.sharedController.myBooks, let cell = sender as? ProfileBookCollectionViewCell, let indexPath = collectionView.indexPathForCell(cell) {
            
            let book = books[indexPath.row]
            vc.book = book
            if let image = cell.bookImageView.image {
                vc.loadedImage = image
            }
        }
     }
    
    
    
    // MARK: - VIEW SETUP
    func setUpView() {
        //        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        //        profileImageView.clipsToBounds = true
        //        profileImageView.layer.masksToBounds = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        configureViewShadow()
        configureTab(currentViewState)
    }
    
    func adjustViewForLogin(){
        if let currentUser = UserController.sharedController.currentUser {
            title = currentUser.name
            if let image = currentUser.imageURL {
                configureProfileImage(image)
            }
            collectionView.backgroundView = nil
            observeMyBooks()
        } else {
            // Logged Out
            configureBackGroundButton()
            title = ""
            profileImageView.image = nil
            collectionView.reloadData()
        }
        tabBarController?.tabBar.items![2].title = ""
        configureTab(currentViewState)
    }
    
    // MARK: - TAB
    
    func configureTab(state:ProfileState) {
        switch state {
        case .Buy:
            
            buyView.backgroundColor = .blackColor()
            sellView.backgroundColor = .whiteColor()
        case .Sell:
            sellView.backgroundColor = .blackColor()
            buyView.backgroundColor = .whiteColor()
        case .LoggedOut:
            sellView.backgroundColor = .whiteColor()
            buyView.backgroundColor = .whiteColor()
        }
    }
    
    @IBAction func tabBarChanged(sender: AnyObject) {
        switch sender.tag {
        case 0:
            self.currentViewState = .Buy
        default:
            self.currentViewState = .Sell
        }
    }
    
    
    func configureProfileImage(imageString:String) {
        if let url = NSURL(string:imageString) {
            ImageController.fetchImageAtURL(url, completion: { (image, error) in
                guard let image = image else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.profileImageView.image = image
                })
            })
        }
    }
    
    func configureViewShadow() {
        topView.layer.shadowColor = UIColor.blackColor().CGColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 4)
        topView.layer.shadowRadius = 4
        topView.layer.shadowOpacity = 0.2
        topView.layer.masksToBounds = false
    }
    
    func configureBackGroundButton() {
        let backButton = UIButton()
        backButton.setTitle("Log In", forState: .Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backButton.addTarget(self, action: #selector(presentLoginViewController), forControlEvents: .TouchUpInside)
        collectionView.backgroundView = backButton
    }
    
    func presentLoginViewController() {
        performSegueWithIdentifier("showSignInSegue", sender: nil)
    }
    
    
    // MARK: - MYBOOKS
    func observeMyBooks() {
        listenForNotifications()
        UserController.sharedController.fetchMyBooks { (success) in
            if success == false {
                let backButton = UIButton()
                backButton.setTitle("Error fetching books.", forState: .Normal)
                backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                self.collectionView.backgroundView = backButton
            }
        }
    }
    
    func listenForNotifications() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(ProfileViewController.reloadBooks), name: myBookNotification, object: nil)
    }
    
    func reloadBooks() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.collectionView.reloadData()
        }
    }
    
    
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileBookCell", forIndexPath: indexPath) as! ProfileBookCollectionViewCell
        
        if let booksForSale = UserController.sharedController.myBooks {
            cell.updateCellForBook(booksForSale[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = UserController.sharedController.currentUser {
            return UserController.sharedController.myBooks?.count ?? 0
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 9, height: collectionView.frame.height/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
}

// MARK: - BarButtonActions
extension ProfileViewController {
    
    @IBAction func dismissTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editTapped(sender: AnyObject) {
    
    }
}

