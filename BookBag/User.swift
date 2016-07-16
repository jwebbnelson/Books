//
//  User.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class User {
    
    var name:String
    var phoneNumber: Int
    var uID: String
    
    
    init(name:String, phoneNumber:Int) {
        self.name = name
        self.phoneNumber = phoneNumber
        uID = ""
    }
    
    
}