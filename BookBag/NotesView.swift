//
//  NotesView.swift
//  BookBag
//
//  Created by Jordan Nelson on 8/29/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class NotesView: UIView {

    @IBOutlet weak var saveButton: UIButton!
    
    func setUp() {
        saveButton.isEnabled = false
    }
    
    func makeSaveable() {
        saveButton.isEnabled = true
        saveButton.setTitleColor(UIColor.actionGreen(), for: UIControlState())
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
