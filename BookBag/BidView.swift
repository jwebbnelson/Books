//
//  BidView.swift
//  BookBag
//
//  Created by Jordan Nelson on 8/24/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class BidView: UIView {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var offerTextField: UITextField!
    @IBOutlet var bidTools: [UIStackView]!
    @IBOutlet weak var askingPriceLabel: UILabel!
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
   
    @IBAction func cancelTapped(_ sender: AnyObject) {
        removeFromSuperview()
    }
    
    
    func configure(_ book:Book) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        confirmButton.setTitleColor(UIColor.gray, for: UIControlState())
        askingPriceLabel.text = "$\(book.price)"
    }

}

extension BidView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
         confirmButton.setTitleColor(UIColor.green, for: UIControlState())
    }
    
    
}
