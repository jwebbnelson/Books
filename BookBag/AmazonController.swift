//
//  AmazonController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class AmazonController: NSObject, NSXMLParserDelegate {
    
    var xmlParser: NSXMLParser!
    
    static let sharedController = AmazonController()
    
    func amazonItemLookup(isbn:String, completion:([Book]?) -> Void) {
        
        let url = NetworkController.createItemLookUpURL(isbn)
        print(url)
        NetworkController.dataAtURL(url) { (resultData) in
            guard let data = resultData else {
                print("NO DATA RETURNED FROM AMAZON ITEM LOOKUP")
                completion(nil)
                return
            }
            
            self.xmlParser = NSXMLParser(data: data)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print(elementName)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print(string)
    }
    
    
    
    
}





