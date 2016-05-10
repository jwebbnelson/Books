//
//  LocationController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import CoreLocation


class LocationController {
    
    static func convertStringToLocation(address:String, completion:(placemark:CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if let _ = error {
                completion(placemark: nil)
                return
            }
            if placemark?.count > 0 {
                let placement = placemark?.first
                completion(placemark: placement)
            } else {
                completion(placemark: nil)
            }
        }
    }
    
}