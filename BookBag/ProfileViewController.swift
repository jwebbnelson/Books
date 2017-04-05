//
//  ProfileViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/20/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum ProfileState {
    case buy, sell, loggedOut
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet var signUpView: UIView!
    
    var currentViewState: ProfileState {
        get {
            if let _ = UserController.sharedController.currentUser {
                if buyView.backgroundColor == UIColor.white {
                    return .sell
                } else {
                    return .buy
                }
            } else {
                return .loggedOut
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        adjustViewForLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? BookDetailTableViewController, let books = UserController.sharedController.myBooks, let cell = sender as? ProfileBookCollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            
            let book = books[(indexPath as NSIndexPath).row]
            vc.book = book
            if let image = cell.bookImageView.image {
                vc.loadedImage = image
            }
        }
     }
    
    
    
    // MARK: - VIEW SETUP
    func setUpView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = UIColor.whiteSmoke()
        configureViewShadow()
        configureTab(currentViewState)
    }
    
    func adjustViewForLogin(){
        if let currentUser = UserController.sharedController.currentUser {
            if let image = currentUser.imageURL {
                configureProfileImage(image)
            }
            topView.alpha = 1
            collectionView.backgroundView = nil
            observeMyBooks()
        } else {
            // Logged Out
            configureBackGroundButton()
            
            profileImageView.image = nil
            collectionView.reloadData()
        }
        tabBarController?.tabBar.items![2].title = ""
        configureTab(currentViewState)
    }
    
    // MARK: - TAB
    
    func configureTab(_ state:ProfileState) {
        switch state {
        case .buy:
            UIView.animate(withDuration: 0.3, animations: {
                self.buyView.backgroundColor = .black
                self.sellView.backgroundColor = .white
                self.sellButton.setTitleColor(UIColor.lightGray, for: UIControlState())
                self.buyButton.setTitleColor(UIColor.black, for: UIControlState())
            })
        case .sell:
            UIView.animate(withDuration: 0.3, animations: {
                self.sellView.backgroundColor = .black
                self.buyView.backgroundColor = .white
                self.buyButton.setTitleColor(UIColor.lightGray, for: UIControlState())
                self.sellButton.setTitleColor(UIColor.black, for: UIControlState())
            })
        case .loggedOut:
            sellView.backgroundColor = .white
            buyView.backgroundColor = .white
        }
        collectionView.reloadData()
    }
    
    @IBAction func tabBarChanged(_ sender: AnyObject) {
        switch sender.tag {
        case 0:
            self.currentViewState = .buy
        default:
            self.currentViewState = .sell
        }
    }
    
    
    func configureProfileImage(_ imageString:String) {
        if let url = URL(string:imageString) {
            ImageController.fetchImageAtURL(url, completion: { (image, error) in
                guard let image = image else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async(execute: {
                    self.profileImageView.image = image
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
                    self.profileImageView.layer.masksToBounds = true
                })
            })
        }
    }
    
    func configureViewShadow() {
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 4)
        topView.layer.shadowRadius = 4
        topView.layer.shadowOpacity = 0.2
        topView.layer.masksToBounds = false
    }
    
    func configureBackGroundButton() {
//        collectionView.backgroundView = signUpView
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        signUpView.frame = (self.view.superview?.frame)!
        view.addSubview(signUpView)
    }
    
    func presentLoginViewController() {
        performSegue(withIdentifier: "showSignInSegue", sender: nil)
    }
    
    
    // MARK: - MYBOOKS
    func observeMyBooks() {
        listenForNotifications()
        
        UserController.sharedController.fetchMyBidBooks()
        UserController.sharedController.fetchMyBooks { (success) in
            if success == false {
                let backButton = UIButton()
                backButton.setTitle("Error fetching books.", for: UIControlState())
                backButton.setTitleColor(UIColor.black, for: UIControlState())
                self.collectionView.backgroundView = backButton
            }
        }
    }
    
    func listenForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ProfileViewController.reloadBooks), name: NSNotification.Name(rawValue: myBookNotification), object: nil)
        nc.addObserver(self, selector: #selector(ProfileViewController.reloadBooks), name: NSNotification.Name(rawValue: myBidsNotification), object: nil)
    }
    
    func reloadBooks() {
        DispatchQueue.main.async { 
            self.collectionView.reloadData()
        }
    }
    
    
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileBookCell", for: indexPath) as! ProfileBookCollectionViewCell
        
        switch currentViewState {
        case .buy:
            if let bids = UserController.sharedController.myBids {
                cell.updateCellForBook(bids[(indexPath as NSIndexPath).row])
            }
        default:
            if let booksForSale = UserController.sharedController.myBooks {
                cell.updateCellForBook(booksForSale[(indexPath as NSIndexPath).row])
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentViewState {
        case .buy:
            return UserController.sharedController.myBids?.count ?? 0
        case .sell:
            return UserController.sharedController.myBooks?.count ?? 0
        case .loggedOut:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 9, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}

// MARK: - BarButtonActions
extension ProfileViewController {
    
    @IBAction func dismissTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: AnyObject) {
    
    }
}

