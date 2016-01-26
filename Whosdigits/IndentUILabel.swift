//
//  IndentUILabel.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 8/7/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit

class IndentUILabel: UILabel{
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 10
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}
