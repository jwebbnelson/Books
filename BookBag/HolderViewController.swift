//
//  HolderViewController.swift
//  BookBag
//
//  Created by Jordan Nelson on 8/3/16.
//  Copyright © 2016 Jordan Nelson. All rights reserved.
//

import UIKit

class HolderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        listenForNotification()
    }
    
    func listenForNotification() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(HolderViewController.resetTabBar), name: SellDismissedNotification, object: nil)
    }
    
    func resetTabBar() {
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        performSegueWithIdentifier("showSellScreenSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
