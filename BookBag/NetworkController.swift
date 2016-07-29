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
        let url = NSURL(string:  "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=AKIAIDPXJJNQOOS2ED5Q&AssociateTag=bookbagapp-20&IdType=ISBN&ItemId=1305263723&Operation=ItemLookup&ResponseGroup=Images%2CItemAttributes%2COffers&SearchIndex=Books&Service=AWSECommerceService&Timestamp=2016-07-29T01%3A47%3A32.000Z&Signature=QahzT8vpp80qhtaG72UTLz5bwQ4qRngOMHWEy6Zm2c4%3D")
        
        return url!
    }
    
}
