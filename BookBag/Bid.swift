//
//  Bid.swift
//  BookBag
//
//  Created by Jordan Nelson on 6/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class Bid {
    
    fileprivate let kUID = "userID"
    fileprivate let kBookID = "bookID"
    fileprivate let kPrice = "price"
    fileprivate let kDate = "date"
    
    var userID:String
    var bookID:String
    var price:Double
//    var date: String
    
    var jsonValue: [String: AnyObject] {
        return [userID: price as AnyObject]
    }
    
    init(userID:String, bookID:String, price:Double) {
        self.userID = userID
        self.bookID = bookID
        self.price = price
    }
}
