//
//  FirebaseController.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/18/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let base = FIRDatabase.database().reference()
    static let storage = FIRStorage.storage()
    
    static let bookBase = base.child("Books")
    static let userBase = base.child("Users")
    static let bidBase = base.child("Bids")
    
    static let storageRef = storage.referenceForURL("gs://bookbag-b2b09.appspot.com")
    static let imagesRef = storageRef.child("images")
    
}