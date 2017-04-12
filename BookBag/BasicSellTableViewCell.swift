//
//  BasicSellTableViewCell.swift
//  BookBag
//
//  Created by Jordan Nelson on 4/25/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class BasicSellTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var entryTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setDetails(_ detail:String, prompt:String) {
        detailLabel.text = detail
        entryTextField.placeholder = prompt
        detailLabel.isHidden = false
    }
    
    func updateForError() {
        if entryTextField.text == nil || entryTextField.text == "" {
            entryTextField.text = entryTextField.placeholder
            entryTextField.textColor = UIColor.red
        }
    }
    
}
