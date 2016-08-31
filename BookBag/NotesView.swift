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
        saveButton.enabled = false
    }
    
    func makeSaveable() {
        saveButton.enabled = true
        saveButton.setTitleColor(UIColor.actionGreen(), forState: .Normal)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
