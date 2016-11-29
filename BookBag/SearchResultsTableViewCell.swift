//
//  SearchResultsTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/7/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var underView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateWithBook(_ book:Book) {
        handleCellImage(book.image)
        titleLabel.text = book.title
        authorLabel.text = "by \(book.author)"
        priceLabel.text = "$\(book.price)"
        locationLabel.text = "Location"
    }
    
    func handleCellImage(_ imageURLString:String) {
        bookImage.image = nil
        if let url = URL(string: imageURLString) {
            ImageController.fetchImageAtURL(url) { (image, error) in
                guard let image = image else {
                    print("FAILURE LOADING IMAGE: \(error.debugDescription)")
                    return
                }
                DispatchQueue.main.async(execute: {
                    self.bookImage.image = image
                })
            }
        }
    }
}
