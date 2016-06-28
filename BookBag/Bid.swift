//
//  Bid.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class Bid {
    
    var userID:String
    var bookID:String
    var price:Double
    
    init(userID:String, bookID:String, price:Double) {
        self.userID = userID
        self.bookID = bookID
        self.price = price
    }
    
    
    
}