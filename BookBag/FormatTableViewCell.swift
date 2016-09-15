//
//  FormatTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 8/12/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class FormatTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    weak var delegate: FormatCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func segmentControlChanged(_ sender: AnyObject) {
        delegate?.formatSelected(segmentedControl.selectedSegmentIndex)
    }
}

protocol FormatCellDelegate: class {
    func formatSelected(_ format: Int)
}
