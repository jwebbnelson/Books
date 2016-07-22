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
    
    
    // LOGIN - SIGNUP
    static func logInUser(email:String, password:String, completion:(errorString:String?)-> Void){
        
    }
    
    static func signUpUser(email:String, password:String, fullName:String, completion:(user: User?,errorString:String?)-> Void){
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            guard let user = user else {
                completion(user: nil, errorString: error.debugDescription)
                return
            }
            let localUser = User(fireUser: user)
            completion(user: localUser, errorString: nil)
        })
    }
    
    static func logOutUser(completion:(success:Bool) -> Void){
        
    }
    
    
    // MY LIBRARY
    static func fetchMyBooks(completion:([Book]?) -> Void) {
        
    }
    
}