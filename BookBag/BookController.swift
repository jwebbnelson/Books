//
//  BookController.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class BookController {
    
    // MARK: - Buying/Searching
    static func queryBooks(searchString:String?, completion:(book:[Book]?) -> Void){
        
        
        FirebaseController.bookBase.queryOrderedByChild("title").queryEqualToValue(searchString).observeSingleEventOfType(FIRDataEventType.Value) { (snapshot, childKey) in
            
            if let bookDictionaries = snapshot.value as? [String: AnyObject] {
                
                let books = bookDictionaries.flatMap({Book(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                completion(book: books)
            } else {
                completion(book: nil)
            }
        }
    }
    
    static func searchAmazonBooks() {
        
    }
    
    // MARK: - Selling
    static func submitTextbookForApproval(author: String, title:String, isbn: String, edition:String?, price:Double, notes:String?, completion:(bookID: String?, error:NSError?) -> Void) {
        
        let book = Book(title: title, author: author, edition: edition, price: price, isbn: isbn, notes:notes)
        FirebaseController.bookBase.childByAutoId().setValue(book.jsonValue) { (error, ref) in
            if let error = error {
                completion(bookID: nil, error: error)
            } else {
                print("Saved REF: \(ref)")
                completion(bookID: ref.key, error: nil)
            }
        }
    }
    
    // MARK: - Photo
    // UPDATE RULES in Console .. after write : if request.auth != null
    static func uploadPhotoToFirebase(bookID:String, image:UIImage, completion:(fileURL:NSURL?, error:NSError?) -> Void) {
        
        if let data: NSData = UIImageJPEGRepresentation(image, 0.5) {
            
            let specificImageRef = FirebaseController.imagesRef.child(bookID)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let uploadTask = specificImageRef.putData(data, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    completion(fileURL: nil, error: error)
                } else {
                    if let imageURL = metaData.downloadURL() {
                        updateBookPath(bookID, imagePath:imageURL)
                    }
                    completion(fileURL:metadata?.downloadURL(), error: nil)
                }
            })
        } else {
            print("UNABLE TO CREATE DATA FROM IMAGE")
            completion(fileURL: nil, error: nil)
        }
    }
    
    static func updateBookPath(bookID:String, imagePath:NSURL) {
        print("ImagePath updated")
        FirebaseController.bookBase.child(bookID).updateChildValues(["image":"\(imagePath)"])
    }
    
    // MARK: - Bidding
    static func bidForBook(price:Double, book:Book, completion:(bid:Bid?) -> Void)  {
        
    }
    
    static func confirmBid(bid:Bid) {
        
    }
    
    // MARK: - Managing (MY BOOKS)
    static func deleteBook(book:Book) {
        
    }
    
}









