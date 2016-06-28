//
//  Book.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Book {
    
    var title: String
    var author: String
    var edition: String
    var location: CLLocation
    var price: Double
//    var image: UIImage
    var recordID: String

    init(title:String, author:String, edition:String, location:CLLocation, price:Double) {
        self.title = title
        self.author = author
        self.location = location
        self.edition = edition
        self.price = price
//        self.image = image
        self.recordID = ""
    }
    
    
    
}






