//
//  UserController.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

public let myBookNotification = "MyBookNotificationName"

class UserController {
    
    private let kUser = "user"
    static let sharedController = UserController()
    
    var currentUser: User? {
        get {
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else {
                    
                    return nil
            }
            
            return User(json: userDictionary, uID: uid)
        }
        
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        
    }
    
    
    var myBooks: [Book]? {
        didSet {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(myBookNotification, object: nil)
        }
    }
    
    // LOGIN - SIGNUP
    func logInUser(email:String, password:String, completion:(errorString:String?)-> Void){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(errorString: error?.localizedDescription)
                return
            }
            self.fetchUserWithUID(user.uid, completion: { (success) in
                if success == true {
                    completion(errorString: nil)
                } else {
                    self.createFirebaseUser(user.uid, name: user.displayName!, email: user.email!, imageURL: user.photoURL, completion: { (success) in
                        if success == true {
                            completion(errorString: nil)
                        } else {
                            completion(errorString: "Unable to create database reference.")
                        }
                    })
                }
            })
        })
    }
    
    func logInWithCredential(credential:FIRAuthCredential, completion:(errorString:String?) -> Void){
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            guard let user = user else {
                if let error = error {
                    completion(errorString: error.localizedDescription)
                }
                return
            }
            self.fetchUserWithUID(user.uid, completion: { (success) in
                if success == true {
                    completion(errorString: nil)
                } else {
                    self.createFirebaseUser(user.uid, name: user.displayName!, email: user.email!, imageURL: user.photoURL, completion: { (success) in
                        if success == true {
                            completion(errorString: nil)
                        } else {
                            completion(errorString: "Unable to create database reference.")
                        }
                    })
                }
            })
        })
    }
    
    func signUpUser(email:String, password:String, completion:(uid:String?, errorString:String?)-> Void){
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(uid: nil, errorString: error?.description)
                return
            }
            completion(uid: user.uid, errorString: nil)
        })
    }
    
    func createFirebaseUser(uID: String, name:String, email:String, imageURL:NSURL?, completion:(success:Bool) -> Void) {
        let user = User(name: name, email: email, imageURL: imageURL?.absoluteString)
        FirebaseController.userBase.child(uID).setValue(user.jsonValue) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                completion(success: false)
                return
            } else {
                UserController.sharedController.currentUser = user
                completion(success: true)
            }
        }
    }
    
    func fetchUserWithUID(uID: String, completion:(success:Bool) -> Void) {
        FirebaseController.userBase.child(uID).observeSingleEventOfType(FIRDataEventType.Value) { (snapshot, _) in
            if let userDictionary = snapshot.value as? [String:AnyObject] {
                if let user = User(json: userDictionary, uID: snapshot.ref.key) {
                    UserController.sharedController.currentUser = user
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            } else {
                completion(success: false)
            }
        }
    }
    
    func logOutUser() {
        try! FIRAuth.auth()?.signOut()
    }
    
    func checkCurrentUser(completion:(currentUser:Bool) -> Void) {
        if let _ = FIRAuth.auth()?.currentUser {
            // User is signed in.
           completion(currentUser: true)
        } else {
            // No user is signed in.
           completion(currentUser: false)
        }
    }
    
    
    // MY LIBRARY
    func fetchMyBooks(completion:(success:Bool) -> Void) {
        if let currentUser = UserController.sharedController.currentUser {
            FirebaseController.bookBase.queryOrderedByChild("ownerID").queryEqualToValue(currentUser.uID).observeEventType(.Value, withBlock: { (snapshot) in
                if let bookDictionaries = snapshot.value as? [String: AnyObject] {
                    self.myBooks = bookDictionaries.flatMap({Book(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            })
        }
    }
    
}