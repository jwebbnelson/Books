//
//  LoginViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/24/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        resetActivityIndicator()
        errorLabel.isHidden = true
        forgotPasswordButton.isHidden = true
        configureGoogle()
    }
    
    func resetActivityIndicator() {
        activityIndicator.layer.transform = CATransform3DMakeScale(0, 0, 0)
        logInButton.setTitle("Log In", for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func logInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            UserController.sharedController.logInUser(email, password: password, completion: { (errorString) in
                if let error = errorString {
                    DispatchQueue.main.async(execute: {
                        print(error)
                        self.resetActivityIndicator()
                        self.showErrorLabel(error)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.removeFromSuperview()
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
            beginLoadingAnimation()
            self.hideErrorLabel()
        }
    }
    
    func beginLoadingAnimation() {
        view.endEditing(true)
        logInButton.setTitle(" ", for: UIControlState())
        activityIndicator.layer.transform = CATransform3DIdentity
        activityIndicator.startAnimating()
    }
    
    func showErrorLabel(_ errorString:String) {
        self.errorLabel.text = errorString
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = false
        }) 
    }
    
    func hideErrorLabel() {
        if errorLabel.isHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorLabel.text = ""
                self.errorLabel.isHidden = true
            }) 
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func forgotPassTapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideErrorLabel()
        if textField == passwordField {
            forgotPasswordButton.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordField {
            forgotPasswordButton.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func configureGoogle() {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.light
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        beginLoadingAnimation()
        if let error = error {
            self.showErrorLabel(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                                     accessToken: (authentication?.accessToken)!)
        UserController.sharedController.logInWithCredential(credential) { (errorString) in
            if let error = errorString {
                DispatchQueue.main.async(execute: {
                    self.showErrorLabel(error)
                })
            } else {
                 print("Google Sign In: - \(user.profile.name)")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

   
}
