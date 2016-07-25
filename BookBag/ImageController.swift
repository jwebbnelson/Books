//
//  ImageController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/19/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
   static func fetchImageAtURL(url: NSURL, completion: (image: UIImage?, error: NSError?) -> Void) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let data = data, let image = UIImage(data: data){
                completion(image: image, error: nil)
            } else {
                completion(image: nil, error: error)
            }
            }.resume()
    }
    
    
    
}