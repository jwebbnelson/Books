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
    
    
    static func submitTextbookForApproval(completion:(error:NSError?)-> Void) {
        
//        let recordID = CKRecordID(recordName: "Book")
        
        let record = CKRecord(recordType: "Book")
        let container = CKContainer.defaultContainer()
        
        record["Author"] = "John, Smith"
        record["Title"] = "Really Cool Title"
        record["ISBN"] = "8493833990"
        record["Edition"] = "1st"
        record["Price"] = 12.00
        LocationController.convertStringToLocation("Salt Lake City, Ut", completion: { (placemark) in
            if let placemark = placemark {
                record["Location"] = placemark.location 
            }
            container.publicCloudDatabase.saveRecord(record, completionHandler: { (record, error) in
                if let error = error {
                    completion(error: error)
                    return
                } else {
                    completion(error: nil)
                }
            })
        })
    }
    
    
    static func queryBooks(searchString:String, completion:(book:[Book]?) -> Void){
        let publicDataBase = CKContainer.defaultContainer().publicCloudDatabase
        
        let predicate = NSPredicate(format: "Title = 'Really Cool Title'")
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









