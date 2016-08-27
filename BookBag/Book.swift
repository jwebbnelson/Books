//
//  Book.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import CoreLocation


public enum BookFormat: Int {
    case Paperback,
    Hardcover
}

class Book: Equatable {
    
    private let kTitle = "title"
    private let kAuthor = "author"
    private let kEdition = "edition"
    private let kPrice = "price"
    private let kLocation = "location"
    private let kImage = "image"
    private let kNotes = "notes"
    private let kISBN = "isbn"
    private let kOwnerID = "ownerID"
    private let kFormat = "format"
    
    var title: String
    var author: String
    var edition: String?
 // var location: CLLocation
    var price: Double
    var image: String
    var notes: String?
    var isbn: String
    var uID: String
    var ownerID: String
    var format: String
    
    var jsonValue: [String: AnyObject] {
    
        var json: [String: AnyObject] = [kTitle: title, kAuthor: author, kPrice: price, kLocation:kLocation, kISBN: isbn,
                                         kImage:"", kOwnerID:ownerID]
        
        if let edition = edition {
            json[kEdition] = edition
        }
        
        if let notes = notes {
            json[kNotes] = notes
        }
        
        return json
    }
    

    init(title:String, author:String, edition:String?, location:CLLocation = CLLocation(), price:Double, isbn: String, notes:String?, ownerID:String, format: String) {
        self.title = title
        self.author = author
//        self.location = location
        self.edition = edition
        self.price = price
        self.image = ""
        self.notes = notes
        self.isbn = isbn
        self.ownerID = ownerID
        self.uID = ""
        self.format = format
    }
    
    
    init?(json:[String:AnyObject], identifier:String) {
        guard let title = json[kTitle] as? String,
        let author = json[kAuthor] as? String,
        let price = json[kPrice] as? Double,
        let isbn = json[kISBN] as? String,
        let image = json[kImage] as? String,
        let ownerID = json[kOwnerID] as? String,
        let format = json[kFormat] as? String else { return nil }
        
        self.title = title
        self.author = author
        self.price = price
        self.isbn = isbn
        self.image = image
        self.ownerID = ownerID
        self.format = format
        
        self.notes = json[kNotes] as? String
        self.edition = json[kEdition] as? String
        
        self.uID = identifier
    }
}

func == (lhs:Book, rhs:Book) -> Bool {
    return  (lhs.isbn == rhs.isbn) && (lhs.uID == rhs.uID)
}







