//
//  JMBackgroundCameraView.swift
//  JMSwiftBackgroundCameraView
//
//  Created by Joan Molinas on 2/11/14.
//  Copyright (c) 2014 joan molinas ramon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum DevicePosition : Int {
    case Front
    case Back
}
class JMBackgroundCameraView: UIView {
    
    var session = AVCaptureSession()
    var input = AVCaptureDeviceInput()
    var deviceInput: AVCaptureDeviceInput?
    var device = AVCaptureDevice?()
    var imageOutput = AVCaptureStillImageOutput()
    var preview = AVCaptureVideoPreviewLayer()
    var blurEffectView =  UIVisualEffectView()

    init(frame: CGRect, position: DevicePosition) {
        super.init(frame: frame)
        initCameraInPosition(position)
    }
    
    init(frame: CGRect, position: DevicePosition, blur: UIBlurEffectStyle) {
        super.init(frame: frame)
        initCameraInPosition(position)
        addBlurEffect(blur)
        
    }
   
    func initCameraInPosition(position: DevicePosition) {
        
       
       session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        var devices = NSArray()
        devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in devices {
            if position == .Back {
                if  device.position  == AVCaptureDevicePosition.Back {
                    self.device = device as? AVCaptureDevice
                }
            } else {
                if device.position == AVCaptureDevicePosition.Back {
                    self.device = device as? AVCaptureDevice
                }
            }
        }
        
        let error = NSErrorPointer()
        let outputSettings = NSDictionary(dictionary:[AVVideoCodecKey:AVVideoCodecJPEG])
        
        do {
            self.deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error1 as NSError {
            error.memory = error1
            self.deviceInput = nil
        }
        if session.canAddInput(self.deviceInput) {
            session.addInput(self.deviceInput)
        }
        
        
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = outputSettings as! [NSObject : AnyObject]
        session.addOutput(imageOutput)
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame = frame
        layer.addSublayer(preview)
        session.startRunning()

    }
    
    func stopTakingVideo() -> Void{
        self.session.stopRunning()
    }
    
    func startTakingVideo() -> Void{
        self.session.startRunning()
    }
    
    func removeBlurEffect() {
        blurEffectView.removeFromSuperview()
    }
    
    func addBlurEffect(style : UIBlurEffectStyle) {
        let blur = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = bounds
        
        insertSubview(blurEffectView, atIndex: 1)
        
    }
    
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
