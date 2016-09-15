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
    static func queryBooks(_ searchString:String?, completion:@escaping (_ book:[Book]?) -> Void){
        
        FirebaseController.bookBase.queryOrdered(byChild: "title").queryEqual(toValue: searchString).observeSingleEvent(of: FIRDataEventType.value) { (snapshot, childKey) in
            
            if let bookDictionaries = snapshot.value as? [String: AnyObject] {
                
                let books = bookDictionaries.flatMap({Book(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                completion(books)
            } else {
                completion(nil)
            }
        }
    }
    
    static func searchAmazonBooks() {
        
    }
    
    static func bookForBookID(_ id:String, completion:@escaping (Book?) -> Void) {
        FirebaseController.bookBase.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let bookDictionary = snapshot.value as? [String: AnyObject] {
                if let book = Book(json: bookDictionary, identifier: id) {
                    completion(book)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        })
    }
    
    // MARK: - Selling
    static func submitTextbookForApproval(_ author: String, title:String, isbn: String, edition:String?, price:Double, notes:String?, format:String, completion:@escaping (_ book:Book?, _ bookID: String?, _ error:String?) -> Void) {
        
        if let currentUser = UserController.sharedController.currentUser {
            let book = Book(title: title, author: author, edition: edition, price: price, isbn: isbn, notes:notes, ownerID: currentUser.uID, format: format)
            FirebaseController.bookBase.childByAutoId().setValue(book.jsonValue) { (error, ref) in
                if let error = error {
                    completion(nil, nil, error.localizedDescription)
                } else {
                    print("Saved REF: \(ref)")
                    completion(book, ref.key, nil)
                }
            }
        } else {
            completion(nil, nil, "User Not Logged In")
        }
    }
    
    // MARK: - Photo
    // UPDATE RULES in Console .. after write : if request.auth != null
    static func uploadPhotoToFirebase(_ bookID:String, image:UIImage, completion:@escaping (_ fileURL:URL?, _ error:NSError?) -> Void) {
        
        if let data: Data = UIImageJPEGRepresentation(image, 0.0) {
            
            let specificImageRef = FirebaseController.imagesRef.child(bookID)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let _ = specificImageRef.put(data, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    completion(nil, error as NSError?)
                } else {
                    completion(metadata?.downloadURL(), nil)
                }
            })
        } else {
            print("UNABLE TO CREATE DATA FROM IMAGE")
            completion(nil, nil)
        }
    }
    
    static func updateBookPath(_ bookID:String, imagePath:URL) {
        FirebaseController.bookBase.child(bookID).updateChildValues(["image":"\(imagePath)"])
        print("ImagePath updated")
    }
    
    // MARK: - Bidding
    static func bidForBook(_ sellerID:String, price:Double, book:Book, completion:@escaping (_ success:Bool) -> Void)  {
       // Bids - SellerID - bid
        if let user = UserController.sharedController.currentUser {
            
            let bid = Bid(userID: user.uID, bookID: book.uID, price: price)
            
            FirebaseController.bidBase.child(sellerID).child(book.uID).setValue(bid.jsonValue, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                } else {
                    addBidToUser(bid, user: user, completion: { (success) in
                        completion(success)
                    })
                }
            })
            
        }
    }
    
    static func addBidToUser(_ bid:Bid, user:User, completion: @escaping (_ success:Bool) -> Void) {
        FirebaseController.userBase.child(user.uID).child("Bids").child(bid.bookID).setValue(true) { (error, ref) in
            guard let error = error else {
                completion(true)
                return
            }
            print("FAILURE: Unable to add bid to USER in Firebase \(error.localizedDescription)")
            completion(false)
        }
    }
    
       
    
    static func confirmBid(_ bid:Bid) {
        
    }
    
    // Bids - SellerID - bid
    static func checkForBidOnBook(_ book:Book, completion:@escaping (_ bidAmount:Double?) -> Void) {
        if let user = UserController.sharedController.currentUser {
            FirebaseController.bidBase.child(book.ownerID).child(book.uID).child(user.uID).observeSingleEvent(of: .value, with:  { (snapshot) in
                if snapshot.value == nil {
                    completion(nil)
                } else if let bid = snapshot.value as? [String:AnyObject] {
                    
                }
            })
        } else {
            completion(nil)
        }
        
    }
    
    
    // MARK: - Managing (MY BOOKS)
    static func deleteBook(_ book:Book) {
        
    }
    
}









