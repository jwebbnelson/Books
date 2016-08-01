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
        
        let accessKeyID = "AKIAIDPXJJNQOOS2ED5Q"
        
        let currentTimeStamp = NSDate().amazonFormat()
        
        let url = NSURL(string:  "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=\(accessKeyID)&AssociateTag=bookbagapp-20&IdType=ISBN&ItemId=\(isbn)=ItemLookup&ResponseGroup=Images%2CItemAttributes%2COffers&SearchIndex=Books&Service=AWSECommerceService&Timestamp=\(currentTimeStamp)&Signature=upNFspmlD8%2BWNXrAUTR4jdjV48jrdXpXJ8V0W%2BEQwoo%3D")
        
        
        return url!
    }
    
}
