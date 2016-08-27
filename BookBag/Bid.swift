//
//  Bid.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class Bid {
    
    private let kUID = "userID"
    private let kBookID = "bookID"
    private let kPrice = "price"
    private let kDate = "date"
    
    var userID:String
    var bookID:String
    var price:Double
//    var date: String
    
    var jsonValue: [String: AnyObject] {
        
        return [kUID: userID, kBookID: bookID, kPrice: price]
    }
    
    init(userID:String, bookID:String, price:Double) {
        self.userID = userID
        self.bookID = bookID
        self.price = price
    }
    
}