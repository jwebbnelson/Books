//
//  ExtraSellTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class ExtraSellTableViewCell: UITableViewCell {

    weak var delegate: ExtraButtonsDelgate?
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func photoButtonTapped(sender: AnyObject) {
        delegate?.photosPressed()
    }
    
    @IBAction func notesButtonTapped(sender: AnyObject) {
        delegate?.notesPressed()
    }
}

protocol ExtraButtonsDelgate: class {
    func photosPressed()
    func notesPressed()
}
