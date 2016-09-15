//
//  SignUpViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/24/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.isHidden = true
        resetActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text {
            UserController.sharedController.signUpUser(email, password: password, completion: { (uid, errorString) in
                guard let uID = uid else {
                    print(errorString)
                    return
                }
                UserController.sharedController.createFirebaseUser(uID, name: name, email: email, imageURL: nil, completion: { (success) in
                    UserController.sharedController.logInUser(email, password: password, completion: { (errorString) in
                        
                        if let error = errorString {
                            print(error)
                        } else {
                            DispatchQueue.main.async(execute: {
                                self.resetActivityIndicator()
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    })
                })
            })
            beginLoadingAnimation()
        }
    }
    
    func resetActivityIndicator() {
        activityIndicator.layer.transform = CATransform3DMakeScale(0, 0, 0)
        signUpButton.setTitle("Sign Up", for: UIControlState())
    }
    
    func beginLoadingAnimation() {
        view.endEditing(true)
        signUpButton.setTitle(" ", for: UIControlState())
        activityIndicator.layer.transform = CATransform3DIdentity
        activityIndicator.startAnimating()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func returnToSignInTapped(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}


