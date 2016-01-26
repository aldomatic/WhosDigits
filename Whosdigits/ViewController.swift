//
//  ViewController.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 8/3/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    var phoneNumberHolder: [String] = []
    @IBOutlet weak var cursorBlinker: UIView!
    @IBOutlet weak var numberPadView: UIView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("restartAnimation"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
//        self.view.layoutIfNeeded()
//        UIView.animateWithDuration(0.2, animations: { () -> Void in
//            self.numberPadViewTopConstraint.constant = 150
//            self.view.layoutIfNeeded()
//        })
    
    }
    func restartAnimation(){
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 0.0
        anim.duration = 0.3
        anim.autoreverses = true
        anim.repeatCount = .infinity
        self.cursorBlinker.layer.addAnimation(anim, forKey: nil)
        self.cursorBlinker.alpha = 0.0
    }
    
    func showStepTwo(){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.restartAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func numberButtons(sender: UIButton!) {
        sender.backgroundColor = UIColor(red:0, green:0.99, blue:0.99, alpha:1)
        self.cursorBlinker.hidden = true
            if self.phoneNumberHolder.count == 3{
                self.phoneLabel.text! = self.phoneLabel.text! + "-"
            } else if self.phoneNumberHolder.count == 6{
                self.phoneLabel.text! = self.phoneLabel.text! + "-"
            }
            if self.phoneNumberHolder.count == 10{
               // println("Do Nothing")
            } else {
                self.phoneNumberHolder.append(String(sender.tag))
                self.phoneLabel.text! = self.phoneLabel.text! + String(sender.tag)
            }
        
        //println(self.phoneNumberHolder.count)
    }

    @IBAction func clearPhone(sender: AnyObject) {
        self.phoneNumberHolder = []
        self.phoneLabel.text! = ""
        self.cursorBlinker.hidden = false
        self.restartAnimation()
    }
    
    @IBAction func numberButtonSelected(sender: UIButton) {
        sender.backgroundColor = UIColor(red:0, green:0.89, blue:0.89, alpha:1)
    }
    
    
    
    
  
}

