//
//  ProfileBookCollectionViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/20/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class ProfileBookCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func updateCellForBook(book: Book) {
        handleImage(book.image)
        
    }
    
    func handleImage(imageString: String) {
        bookImageView.image = nil
        if let url = NSURL(string: imageString) {
            ImageController.fetchImageAtURL(url) { (image, error) in
                guard let image = image else {
                    print("FAILURE LOADING IMAGE: \(error?.description)")
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.bookImageView.image = image
                })
            }
        }
    }
    
    func configureShadow() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.cornerRadius = 2
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
}
