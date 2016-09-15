//
//  BookDetailTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/7/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum IconTypes:Int {
    case title
    case author
    case isbn
    case notes
}

class BookDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellWithBook(_ book:Book, row:Int) {
        switch row {
        case IconTypes.title.rawValue:
            updateImage("Title")
            detailLabel.text = book.title
            if let edition = book.edition {
                detailLabel.text = detailLabel.text! + " (Edition \(edition))"
            }
        case IconTypes.author.rawValue:
            updateImage("Author")
            detailLabel.text = book.author
        case IconTypes.isbn.rawValue:
            updateImage("Scan")
            detailLabel.text = "\(book.isbn)"
        case IconTypes.notes.rawValue:
            updateImage("Notes")
            detailLabel.text = book.notes
        default:
            detailLabel.text = ""
        }
    }
    
    func updateImage(_ string:String) {
        iconImage.image = UIImage(named: string)
    }
}
