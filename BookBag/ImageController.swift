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
    
    static func fetchImageAtURL(_ url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        })
        task.resume()
    }
    
    
}
