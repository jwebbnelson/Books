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
public let myBidsNotification = "MyBidsNotificationName"

class UserController {
    
    fileprivate let kUser = "user"
    static let sharedController = UserController()
    
    var currentUser: User? {
        get {
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid,
                let userDictionary = UserDefaults.standard.value(forKey: kUser) as? [String: AnyObject] else {
                    
                    return nil
            }
            
            return User(json: userDictionary, uID: uid)
        }
        
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue.jsonValue, forKey: kUser)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: kUser)
                UserDefaults.standard.synchronize()
            }
        }
        
    }
    
    
    var myBooks: [Book]? {
        didSet {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: myBookNotification), object: nil)
        }
    }
    
    var myBids: [Book]? {
        didSet {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: myBidsNotification), object: nil)
        }
    }
    
    // LOGIN - SIGNUP
    func logInUser(_ email:String, password:String, completion:@escaping (_ errorString:String?)-> Void){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(error?.localizedDescription)
                return
            }
            self.fetchUserWithUID(user.uid, completion: { (success) in
                if success == true {
                    completion(nil)
                } else {
                    self.createFirebaseUser(user.uid, name: user.displayName!, email: user.email!, imageURL: user.photoURL, completion: { (success) in
                        if success == true {
                            completion(nil)
                        } else {
                            completion("Unable to create database reference.")
                        }
                    })
                }
            })
        })
    }
    
    func logInWithCredential(_ credential:FIRAuthCredential, completion:@escaping (_ errorString:String?) -> Void){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            guard let user = user else {
                if let error = error {
                    completion(error.localizedDescription)
                }
                return
            }
            self.fetchUserWithUID(user.uid, completion: { (success) in
                if success == true {
                    completion(nil)
                } else {
                    self.createFirebaseUser(user.uid, name: user.displayName!, email: user.email!, imageURL: user.photoURL, completion: { (success) in
                        if success == true {
                            completion(nil)
                        } else {
                            completion("Unable to create database reference.")
                        }
                    })
                }
            })
        })
    }
    
    func signUpUser(_ email:String, password:String, completion:@escaping (_ uid:String?, _ errorString:String?)-> Void){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(nil, error?.localizedDescription)
                return
            }
            completion(user.uid, nil)
        })
    }
    
    func createFirebaseUser(_ uID: String, name:String, email:String, imageURL:URL?, completion:@escaping (_ success:Bool) -> Void) {
        let user = User(name: name, email: email, imageURL: imageURL?.absoluteString)
        FirebaseController.userBase.child(uID).setValue(user.jsonValue) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                UserController.sharedController.currentUser = user
                completion(true)
            }
        }
    }
    
    func fetchUserWithUID(_ uID: String, completion:@escaping (_ success:Bool) -> Void) {
        FirebaseController.userBase.child(uID).observeSingleEvent(of: FIRDataEventType.value) { (snapshot, _) in
            if let userDictionary = snapshot.value as? [String:AnyObject] {
                if let user = User(json: userDictionary, uID: snapshot.ref.key) {
                    UserController.sharedController.currentUser = user
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func logOutUser() {
        try! FIRAuth.auth()?.signOut()
    }
    
    func checkCurrentUser(_ completion:(_ currentUser:Bool) -> Void) {
        if let _ = FIRAuth.auth()?.currentUser {
            // User is signed in.
           completion(true)
        } else {
            // No user is signed in.
           completion(false)
        }
    }
    
    
    // MARK: - MY LIBRARY
    func fetchMyBooks(_ completion:@escaping (_ success:Bool) -> Void) {
        if let currentUser = UserController.sharedController.currentUser {
            FirebaseController.bookBase.queryOrdered(byChild: "ownerID").queryEqual(toValue: currentUser.uID).observe(.value, with: { (snapshot) in
                if let bookDictionaries = snapshot.value as? [String: AnyObject] {
                    self.myBooks = bookDictionaries.flatMap({Book(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    // MARK: - My Bids
    func fetchMyBidBooks() -> Void {
        self.fetchUserBids { (boookIDs) in
            guard let bookIDs = boookIDs else {
                return
            }
            
            self.myBids = []
            let dispatchGroup = DispatchGroup()
            
            for bookID in bookIDs {
                dispatchGroup.enter()
                BookController.bookForBookID(bookID, completion: { (book) in
                    if let book = book {
                        UserController.sharedController.myBids?.append(book)
                    }
                    dispatchGroup.leave()
                })
            }
        }
    }

    
    func fetchUserBids(_ completion:@escaping (_ boookIDs:[String]?) -> Void ){
        
        if let user = UserController.sharedController.currentUser {
            
            FirebaseController.userBase.child(user.uID).child("Bids").observeSingleEvent(of: .value, with: { (snap) in
                
                var bookIDs:[String] = []
                if let bidArray = snap.value as? [String:AnyObject]  {
                    for bid in bidArray {
                        bookIDs.append(bid.0)
                    }
                    completion(bookIDs)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    
}



