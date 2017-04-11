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

enum LoginState {
    case signUp, login, emailSignUp, forgotPassword, loggedIn
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
    
    // Login Flow
    @IBOutlet weak var textStack: UIStackView!
    @IBOutlet weak var loginSignupToggleButton: UIButton!
    @IBOutlet weak var accoutToggleLabel: UILabel!
    @IBOutlet weak var accountToggleStack: UIStackView!
    @IBOutlet weak var forgotPasswordStack: UIStackView!
    @IBOutlet weak var topButtonStack: UIStackView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var topLabelStack: UIStackView!
    @IBOutlet weak var fullNameStack: UIStackView!
    @IBOutlet weak var topGoogleButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var termsConditionsStack: UIStackView!
    
    
    var currentLoginState: LoginState = .signUp
    
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
        updateLoginView(loginState: .signUp)
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
    
    //MARK: - LOGIN STATE
    @IBAction func loginSignupToggle(_ sender: Any) {
        view.endEditing(true)
        switch currentLoginState {
        case .signUp:
            currentLoginState = .login
            updateLoginView(loginState: .login)
        case .login:
            currentLoginState = .signUp
            updateLoginView(loginState: .signUp)
        default: // Email Sign-Up
            currentLoginState = .login
            updateLoginView(loginState: currentLoginState)
        }
    }
    
    @IBAction func forgotPassResetTapped(_ sender: Any) {
        view.endEditing(true)
        guard let email = emailField.text, !email.isEmpty else {
           self.forgottenPasswordAlert(emailEntered: false)
            return
        }
        self.forgottenPasswordAlert(emailEntered: true)
    }
    
    //MARK: COLORED BUTTONS
    @IBAction func topGoogleButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func bottomEmailButtonTapped(_ sender: Any) {
        if self.currentLoginState == .signUp {
            currentLoginState = .emailSignUp
            updateLoginView(loginState: currentLoginState)
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

// MARK: - Login Flow
extension ProfileViewController {
    
    func updateLoginView(loginState:LoginState){
        
        switch loginState {
        case .signUp:
            print("Current State: SignUp")
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.textStack.isHidden = true
                self.forgotPasswordStack.isHidden = true
                self.forgotPasswordStack.alpha = 0
                self.loginSignupToggleButton.setTitle("Log in here", for: .normal)
                self.loginSignupToggleButton.isHidden = false
                self.topLabelStack.alpha = 1
                self.topLabelStack.isHidden = false
                self.accoutToggleLabel.text = "Already have an account?"
                self.accountToggleStack.isHidden = false
                self.topButtonStack.isHidden = false
                // Buttons 
                self.topGoogleButton.setTitle("  Sign up with Google", for: .normal)
                self.emailButton.setTitle("E-Mail", for: .normal)
                self.termsConditionsStack.isHidden = false
                // Textfields 
                self.fullNameStack.isHidden = true
            }) { (success) in
                print("Animation complete")
            }
        case .login:
            print("Current State: Login")
            self.termsConditionsStack.isHidden = true
            self.forgotPasswordStack.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.topLabelStack.alpha = 0
                self.topLabelStack.isHidden = true
                self.textStack.isHidden = false
                self.loginSignupToggleButton.setTitle("Sign up now!", for: .normal)
                self.loginSignupToggleButton.isHidden = false
                self.accoutToggleLabel.text = "No account yet?"
                self.accountToggleStack.isHidden = false

                self.forgotPasswordStack.alpha = 1
                self.topButtonStack.isHidden = false
                self.topButtonStack.alpha = 1
                // Buttons
                self.topGoogleButton.setTitle("  Sign in with Google", for: .normal)
                self.emailButton.setTitle("Log in", for: .normal)
                
                // Textfields
                self.fullNameStack.isHidden = true
            }) { (success) in
                print("Animation complete")
            }
        default:
             self.termsConditionsStack.isHidden = false
             print("Current State: Email Sign-Up (Default")
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                // Textfields
                self.textStack.isHidden = false
                self.fullNameStack.isHidden = false
                self.textStack.alpha = 1
              
                
                self.topLabelStack.alpha = 0
                self.accountToggleStack.isHidden = false
                self.forgotPasswordStack.isHidden = true
                self.forgotPasswordStack.alpha = 0
                // Buttons
                self.topButtonStack.alpha = 0
                self.topButtonStack.isHidden = true
                self.emailButton.setTitle("Sign up", for: .normal)
                self.loginSignupToggleButton.setTitle("Log in here", for: .normal)
                // Labels
                self.accoutToggleLabel.text = "Already have an account?"
                self.topLabelStack.alpha = 0
                self.topLabelStack.isHidden = true
               
            }) { (success) in
                print("Animation complete")
            }
        }
    }
    
    func forgottenPasswordAlert(emailEntered:Bool){
        if emailEntered == false {
            let alert = UIAlertController(title: "Enter email or username", message: "Then tap Forgot Password to receive a link to reset your password", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Reset Password Email Sent", message: "Please check your inbox for the email address associated with theis account.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

        }
    }
}
























