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
    
    // LOGIN - SIGNUP
    static func logInUser(email:String, password:String, completion:(errorString:String?)-> Void){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(errorString: error?.description)
                return
            }
            fetchUserWithUID(user.uid, completion: { 
                completion(errorString: nil)
            })
            
        })
    }
    
    static func signUpUser(email:String, password:String, completion:(uid:String?, errorString:String?)-> Void){
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(uid: nil, errorString: error?.description)
                return
            }
                completion(uid: user.uid, errorString: nil)
          
        })
    }
    
    static func createFirebaseUser(uID: String, name:String, email:String, school:String, completion:(success:Bool) -> Void) {
        let user = User(name: name, email: email, school: school)
        FirebaseController.userBase.child(uID).setValue(user.jsonValue) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                completion(success: false)
                return
            } else {
                completion(success: true)
            }
        }
    }
    
    static func fetchUserWithUID(uID: String, completion:() -> Void) {
        FirebaseController.userBase.child(uID).observeSingleEventOfType(FIRDataEventType.Value) { (snapshot, _) in
            if let userDictionary = snapshot.value as? [String:AnyObject] {
                if let user = User(json: userDictionary, uID: snapshot.ref.key) {
                    UserController.sharedController.currentUser = user
                }
                completion()
            }
        }
    }
    
    static func logOutUser() {
        try! FIRAuth.auth()?.signOut()
    }
    
    static func checkCurrentUser(completion:(currentUser:Bool) -> Void) {
//       try! FIRAuth.auth()?.signOut()
        if let _ = FIRAuth.auth()?.currentUser {
            // User is signed in.
           completion(currentUser: true)
        } else {
            // No user is signed in.
           completion(currentUser: false)
        }
    }
    
    
    // MY LIBRARY
    static func fetchMyBooks(completion:([Book]?) -> Void) {
        
    }
    
}