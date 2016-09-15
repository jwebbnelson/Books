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
    
   static func fetchImageAtURL(_ url: URL, completion: @escaping (_ image: UIImage?, _ error: NSError?) -> Void) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
            
            if let data = data, let image = UIImage(data: data){
                completion(image, nil)
            } else {
                completion(nil, error)
            }
            } as! (Data?, URLResponse?, Error?) -> Void) .resume()
    }
    
    
    
}
