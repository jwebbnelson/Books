//
//  User.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    private let kName = "name"
    private let kPhone = "phone"
    private let kUniversity = "university"
    private let kImage = "image"
    
    var name:String
    var phoneNumber: Int?
    var uID: String
    var university: String
    var imageURL: String?
    
    
    init(name:String, email:String, school:String) {
        self.name = name
        self.university = school
        uID = ""
    }
    
    var jsonValue: [String:AnyObject] {
        
        var json: [String:AnyObject] = [kName:name, kUniversity: university]
        
        if let phoneNumber = phoneNumber {
            json[kPhone] = phoneNumber
        }
        
        if let imageURL = imageURL {
            json[kImage] = imageURL
        }
        
        return json
    }
    
    init?(json:[String:AnyObject], uID: String) {
        guard let name = json[kName] as? String,
            let university = json[kUniversity] as? String else { return nil}
        
        self.uID = uID
        self.name = name
        self.university = university
        self.imageURL = json[kImage] as? String
        self.phoneNumber = json[kPhone] as? Int
    }
    
}