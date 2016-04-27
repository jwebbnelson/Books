//
//  BookController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import CloudKit

class BookController {
    
    
    static func submitTextbookForApproval(author: String, title:String, isbn: String, edition:String, price:Double, notes:String?, location: CLLocation, completion:(error:NSError?) -> Void) {
        
        let record = CKRecord(recordType: "Book")
        let container = CKContainer.defaultContainer()
        
        record["Author"] = author
        record["Title"] = title
        record["ISBN"] = isbn
        record["Edition"] = edition
        record["Price"] = price
        record["Notes"] = notes ?? ""
        container.publicCloudDatabase.saveRecord(record, completionHandler: { (record, error) in
            if let error = error {
                completion(error: error)
                return
            } else {
                completion(error: nil)
            }
        })
    }
    
    static func queryBooks(searchString:String, completion:(book:[Book]?) -> Void){
        let publicDataBase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(format: "Title = '\(searchString)'")
        let query = CKQuery(recordType: "Book", predicate: predicate)
        publicDataBase.performQuery(query, inZoneWithID: nil) { (records, error) in
            if error == nil {
                let books = records?.flatMap({Book(record:$0)})
                completion(book: books)
            } else {
                 completion(book: nil)
            }
        }
    }
}









