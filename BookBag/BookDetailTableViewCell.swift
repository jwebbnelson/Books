//
//  BookDetailTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/7/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum IconTypes:Int {
    case Title
    case Author
    case ISBN
    case Notes
}

class BookDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellWithBook(book:Book, row:Int) {
        switch row {
        case IconTypes.Title.rawValue:
            updateImage("Title")
            detailLabel.text = book.title
        case IconTypes.Author.rawValue:
            updateImage("Author")
            detailLabel.text = book.author
        case IconTypes.ISBN.rawValue:
            updateImage("Scan")
            detailLabel.text = "\(book.isbn)"
        case IconTypes.Notes.rawValue:
            updateImage("Notes")
            detailLabel.text = book.notes
        default:
            detailLabel.text = ""
        }
    }
    
    func updateImage(string:String) {
        iconImage.image = UIImage(named: string)
    }
}
