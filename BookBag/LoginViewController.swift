//
//  LoginViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/24/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loadingView: LoadingView!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.hidden = false
    }
    
    @IBAction func logInTapped(sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            UserController.logInUser(email, password: password, completion: { (errorString) in
                if let error = errorString {
                    print(error)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingView.removeFromSuperview()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            })
            beginLoadingAnimation()
        }
    }
    
    func beginLoadingAnimation() {
        view.endEditing(true)
        loadingView.center.x = view.center.x
        loadingView.center.y = view.center.y
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.updateLabel("Signing In.")
        loadingView.beginLoading()
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
