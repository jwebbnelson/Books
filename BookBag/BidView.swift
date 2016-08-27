//
//  BidView.swift
//  BookBag
//
//  Created by Jordan Nelson on 8/24/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

enum BidViewState {
    case Bid, Question
}

class BidView: UIView {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var explanationStack: UIStackView!
    @IBOutlet weak var offerTextField: UITextField!
    @IBOutlet var bidTools: [UIStackView]!
    
    var currentState: BidViewState = .Bid
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBAction func questionTapped(sender: AnyObject) {
        switch currentState {
        case .Bid:
            currentState = .Question
            UIView.animateWithDuration(0.3, animations: { 
                self.explanationStack.hidden = true
                for item in self.bidTools {
                    item.hidden = false
                }
               
            })
            
        case .Question:
            currentState = .Bid
            UIView.animateWithDuration(0.3, animations: {
                for item in self.bidTools {
                    item.hidden = true
                }
                self.explanationStack.hidden = false
            })
            
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        removeFromSuperview()
    }
    
    @IBAction func confirmTapped(sender: AnyObject) {
        
    }
    
    func configure() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        explanationStack.hidden = true
        confirmButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
    }

}

extension BidView: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
         confirmButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
    }
    
    
}
