//
//  MessageComposer.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 11/17/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import Foundation
import MessageUI


class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate{
    
    
    func canSendText() -> Bool{
        return MFMessageComposeViewController.canSendText()
    }
    
    
    func configureMessageComposerViewController(contatName: String, contactPhone: Array<String>) -> MFMessageComposeViewController{
      let messageComposerVC = MFMessageComposeViewController()
        messageComposerVC.messageComposeDelegate = self
        messageComposerVC.recipients = contactPhone
        messageComposerVC.body = "Hey (contatName), It's me!"
        return messageComposerVC
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}