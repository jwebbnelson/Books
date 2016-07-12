//
//  BookController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase

class BookController {
    
    // Buying
    static func queryBooks(searchString:String?, completion:(book:[Book]?) -> Void){
        
        
        FirebaseController.bookBase.queryOrderedByChild("title").queryEqualToValue(searchString).observeSingleEventOfType(FIRDataEventType.Value) { (snapshot, childKey) in
            
            if let bookDictionaries = snapshot.value as? [String: AnyObject] {
                
                let books = bookDictionaries.flatMap({Book(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                completion(book: books)
            } else {
                completion(book: nil)
            }
        }
    }
    
    static func searchAmazonBooks() {
        
    }
    
    // Selling
    static func submitTextbookForApproval(author: String, title:String, isbn: String, edition:String?, price:Double, notes:String?, completion:(error:NSError?) -> Void) {
        
        let book = Book(title: title, author: author, edition: edition, price: price, isbn: isbn, notes:notes)
        FirebaseController.bookBase.childByAutoId().setValue(book.jsonValue) { (error, ref) in
            if let error = error {
                completion(error: error)
            } else {
                print("Saved REF: \(ref)")
                completion(error: nil)
            }
        }   
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









