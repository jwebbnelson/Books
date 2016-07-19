//
//  LoadingView.swift
//  BookBag
//
//  Created by Jordan Nelson on 7/17/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateLabel(message:String) {
        label.text = message
    }

}
