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
    
    static let bookBase = base.child("Books")
    
}