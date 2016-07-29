//
//  NetworkController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class NetworkController {
    
    // MARK: - dataAtURL
    static func dataAtURL (url: NSURL, completion:(resultData: NSData?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(resultData: data)
        }
        dataTask.resume()
    }
    
    
    
    
    // MARK: - URLs
    static func createItemLookUpURL(isbn:String) -> NSURL {
        let url = NSURL(string:  "http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemLookup&SubscriptionId=AKIAIDPXJJNQOOS2ED5Q&AssociateTag=bookbagapp-20&ItemId=1305263723&IdType=ISBN&ResponseGroup=Images,ItemAttributes,Offers&SearchIndex=Books")
        
        return url!
    }
    
}
