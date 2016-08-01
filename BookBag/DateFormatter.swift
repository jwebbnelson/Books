//
//  DateFormatter.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/30/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

extension NSDate {
    
    func amazonFormat() -> String {
        
        let formatter = NSDateFormatter()

        formatter.dateFormat = "yyyy-MM-dd*hh MM ss.000"
        
        var dateString = formatter.stringFromDate(NSDate())
        dateString = dateString.stringByReplacingOccurrencesOfString("*", withString: "T")
        dateString = dateString.stringByReplacingOccurrencesOfString(" ", withString: "%3A")
        //  5:39:00 PM
        // T23%3A39%3A00.000Z
        
        dateString += "Z"
        print(dateString)
        return dateString
    }
}