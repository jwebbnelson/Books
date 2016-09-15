//
//  LocationController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class LocationController {
    
    static func convertStringToLocation(_ address:String, completion:@escaping (_ placemark:CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if let _ = error {
                completion(nil)
                return
            }
            if placemark?.count > 0 {
                let placement = placemark?.first
                completion(placement)
            } else {
                completion(nil)
            }
        }
        
    }
    
}
