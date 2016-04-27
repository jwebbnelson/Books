//
//  Book.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Book {
    
    var title: String
    var author: String
    var edition: String
    var location: CLLocation
    var price: Double
//    var image: UIImage
    var recordID: String

    init(title:String, author:String, edition:String, location:CLLocation, price:Double,  recordID:String) {
        self.title = title
        self.author = author
        self.location = location
        self.edition = edition
        self.price = price
//        self.image = image
        self.recordID = recordID
    }
    
    
    init?(record:CKRecord) {
        guard let title = record["Title"] as? String, let author = record["Author"] as? String, let edition = record["Edition"] as? String, let location = record["Location"] as? CLLocation, let price = record["Price"] as? Double else {
            return nil
        }
        self.title = title
        self.author = author
        self.edition = edition
        self.location = location
        self.recordID = record.recordID.recordName
        self.price = price
    }
    
}






