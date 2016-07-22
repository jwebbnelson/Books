//
//  User.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class User {
    
    var name: String
    var university: String?
    var email: String
    var uID: String
    
    init(name:String, university:String, email:String) {
        self.name = name
        self.university = university
        self.email = email
        uID = ""
    }
    
    init(fireUser:FIRUser) {
        if let email = fireUser.email {
            self.email = email
        } else {
            self.email = ""
        }
        self.name = fireUser.displayName ?? ""
        
        
        self.university = "University"
        self.uID = fireUser.uid
        
    }
    
    
}