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
        
        let record = CKRecord(recordType: "Book")
        let container = CKContainer.defaultContainer()
        
        record["Author"] = "John, Smith"
        record["Title"] = "Really Cool Title"
        record["ISBN"] = "8493833990"
        LocationController.convertStringToLocation("Salt Lake City, Ut", completion: { (location) in
            if let location = location {
                record["location"] = location
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
}









