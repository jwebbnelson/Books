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
    
    static func signUpUser(email:String, password:String, fullName:String, completion:(errorString:String?)-> Void){
        
    }
    
    static func logOutUser(completion:(success:Bool) -> Void){
        
    }
    
    static func checkCurrentUser(completion:(currentUser:Bool) -> Void) {
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