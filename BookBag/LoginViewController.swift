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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        resetActivityIndicator()
        errorLabel.hidden = true
        forgotPasswordButton.hidden = true
        configureGoogle()
    }
    
    func resetActivityIndicator() {
        activityIndicator.layer.transform = CATransform3DMakeScale(0, 0, 0)
        logInButton.setTitle("Log In", forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.hidden = false
    }
    
    @IBAction func logInTapped(sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            UserController.logInUser(email, password: password, completion: { (errorString) in
                if let error = errorString {
                    dispatch_async(dispatch_get_main_queue(), {
                        print(error)
                        self.resetActivityIndicator()
                        self.showErrorLabel(error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.removeFromSuperview()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            })
            beginLoadingAnimation()
            self.hideErrorLabel()
        }
    }
    
    func beginLoadingAnimation() {
        view.endEditing(true)
        logInButton.setTitle(" ", forState: .Normal)
        activityIndicator.layer.transform = CATransform3DIdentity
        activityIndicator.startAnimating()
    }
    
    func showErrorLabel(errorString:String) {
        self.errorLabel.text = errorString
        UIView.animateWithDuration(0.3) {
            self.errorLabel.hidden = false
        }
    }
    
    func hideErrorLabel() {
        if errorLabel.hidden == false {
            UIView.animateWithDuration(0.3) {
                self.errorLabel.text = ""
                self.errorLabel.hidden = true
            }
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
    @IBAction func forgotPassTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.hideErrorLabel()
        if textField == passwordField {
            forgotPasswordButton.hidden = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == passwordField {
            forgotPasswordButton.hidden = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func configureGoogle() {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.Light
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        if let error = error {
            self.showErrorLabel(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        UserController.logInWithCredential(credential) { (errorString) in
            if let error = errorString {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorLabel(error)
                })
            } else {
                 print("Google Sign In: - \(user.profile.name)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - GoogleSignIn
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }

    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
   
}
