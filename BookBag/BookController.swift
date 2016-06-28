//
//  BookController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class BookController {
    
    // Buying
    static func queryBooks(searchString:String, completion:(book:[Book]?) -> Void){
        completion(book: nil)
        
    }
    
    static func searchAmazonBooks() {
    }
    
    // Selling
    static func submitTextbookForApproval(author: String, title:String, isbn: String, edition:String, price:Double, notes:String?, completion:(error:NSError?) -> Void) {
        
    }
    
    // Bidding
    static func bidForBook(price:Double, book:Book, completion:(bid:Bid?) -> Void)  {
        
    }
    
    static func confirmBid(bid:Bid) {
        
    }
    
    // Managing (MY BOOKS)
    static func deleteBook(book:Book) {
        
    }
    
}









