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
    
    fileprivate let kName = "name"
    fileprivate let kPhone = "phone"
    fileprivate let kImage = "image"
    
    var name:String
    var phoneNumber: Int?
    var uID: String
    var imageURL: String?
    
    
    init(name:String, email:String, imageURL: String?) {
        self.name = name
        if let image = imageURL {
            self.imageURL = image
        }
        uID = ""
    }
    
    var jsonValue: [String:AnyObject] {
        
        var json: [String:AnyObject] = [kName:name as AnyObject]
        
        if let phoneNumber = phoneNumber {
            json[kPhone] = phoneNumber as AnyObject?
        }
        
        if let imageURL = imageURL {
            json[kImage] = imageURL as AnyObject?
        }
        
        return json
    }
    
    init?(json:[String:AnyObject], uID: String) {
        guard let name = json[kName] as? String else { return nil}
        
        self.uID = uID
        self.name = name
        self.imageURL = json[kImage] as? String
        self.phoneNumber = json[kPhone] as? Int
    }
    
}
