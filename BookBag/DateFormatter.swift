//
//  DateFormatter.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/30/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

extension Date {
    
    func amazonFormat() -> String {
        
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd*hh MM ss.000"
        
        var dateString = formatter.string(from: Date())
        dateString = dateString.replacingOccurrences(of: "*", with: "T")
        dateString = dateString.replacingOccurrences(of: " ", with: "%3A")
        //  5:39:00 PM
        // T23%3A39%3A00.000Z
        
        dateString += "Z"
        print(dateString)
        return dateString
    }
}
