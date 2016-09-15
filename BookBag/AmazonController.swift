//
//  AmazonController.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/28/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation

class AmazonController: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    
    static let sharedController = AmazonController()
    
    func amazonItemLookup(_ isbn:String, completion:@escaping ([Book]?) -> Void) {
        
        let url = NetworkController.createItemLookUpURL(isbn)
        print(url)
        NetworkController.dataAtURL(url) { (resultData) in
            guard let data = resultData else {
                print("NO DATA RETURNED FROM AMAZON ITEM LOOKUP")
                completion(nil)
                return
            }
            
            self.xmlParser = XMLParser(data: data)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print(elementName)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
    
    
    
    
}





