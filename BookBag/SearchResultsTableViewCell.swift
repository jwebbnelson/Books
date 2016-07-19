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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateWithBook(book:Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        priceLabel.text = "$\(book.price)"
        locationLabel.text = "Location"
    }
}
