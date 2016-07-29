//
//  AmazonController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class AmazonController {
    
    
    static func amazonItemLookup(isbn:String, completion:([Book]?) -> Void) {
        
        let url = NetworkController.createItemLookUpURL(isbn)
        
        NetworkController.dataAtURL(url) { (resultData) in
            guard let data = resultData else {
                print("NO DATA RETURNED FROM AMAZON ITEM LOOKUP")
                completion(nil)
                return
            }
            
//            let resultsAnyObject = try NSJSONSerialization
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
}





