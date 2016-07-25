//
//  ProfileViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/20/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum ProfileState:Int {
    case Buy,
        Sell
}

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    var booksForSale: [Book]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
  
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setUpView() {
        //        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        //        profileImageView.clipsToBounds = true
        //        profileImageView.layer.masksToBounds = false
        if let currentUser = UserController.sharedController.currentUser {
            title = currentUser.name
            if let image = currentUser.imageURL {
                configureProfileImage(image)
            }
            UserController.sharedController.fetchMyBooks { (book) in
                self.booksForSale = book
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                })
            }
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        configureViewShadow()
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
    
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileBookCell", forIndexPath: indexPath) as! ProfileBookCollectionViewCell
        
        if let booksForSale = booksForSale {
        cell.updateCellForBook(booksForSale[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksForSale?.count ?? 0
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

// MARK: - StackViewButtons
extension ProfileViewController {
    
    @IBAction func buyTapped(sender: AnyObject) {
        
    }
    
    @IBAction func sellTapped(sender: AnyObject) {
   
    }
}
