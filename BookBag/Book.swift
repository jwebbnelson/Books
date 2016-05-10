//
//  Book.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Book {
    
    private let kTitle = "Title"
    private let kAuthor = "Author"
    private let kEdition = "Edition"
//    private let kLocation: CLLocation
    private let kPrice = "Price"
    private let kImage = "ImageURL"
    
    var title: String
    var author: String
    var edition: String
    var location: CLLocation
    var price: Double
    var imageURL: String
    var uID: String

    init(title:String, author:String, edition:String, location:CLLocation, price:Double, imageURL:String) {
        self.title = title
        self.author = author
        self.location = location
        self.edition = edition
        self.price = price
        self.imageURL = imageURL
        self.uID = ""
    }
    
//    init?(snapshot:FDataSnapshot) {
//        
//        guard let title = snapshot.value[kTitle] as? String, let author = snapshot.value[kAuthor] as? String, let edition = snapshot.value[kEdition] as? String, let price = snapshot.value[kPrice] as? Double,let imageURL = snapshot.value[kImage] as? String else {
//            return
//        }
//        self.title = title
//        self.author = author
//        self.edition = edition
//        self.price = price
//        self.location = CLLocation() // MUST BE CHANGED
//        self.imageURL = imageURL
//        self.uID = snapshot.key // MAY BE LOCATION
//    }
    
}






