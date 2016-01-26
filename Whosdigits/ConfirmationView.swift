//
//  ConfirmationView.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 11/10/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit

class ConfirmationView: UIView{
    
    
   @IBOutlet weak var nameLabel: UILabel!
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func sendConfirmationBtn(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("sendConfirmationSMSToNewContact", object: nil)
    }
    @IBAction func closeConfirmationView(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeContactConfirmationView", object: nil)
    }
}
