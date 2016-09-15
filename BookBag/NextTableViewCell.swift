//
//  NextTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/27/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class NextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextButton: UIButton!
    weak var delegate: SellButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func nextButtonTapped(_ sender: AnyObject) {
        delegate?.sellButtonTapped()
    }
}

protocol SellButtonDelegate: class {
    func sellButtonTapped()
}
