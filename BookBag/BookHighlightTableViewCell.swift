//
//  BookHighlightTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/12/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class BookHighlightTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(book:Book) {
        locationLabel.text = "City, State"
        priceLabel.text = "$\(book.price)"
    }

}
