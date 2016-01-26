//
//  RootViewController.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 8/19/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit
import TagListView
import SQLite

extension String {
    func indexAt(theInt:Int)->String.Index {
        return self.startIndex.advancedBy(theInt)
    }
}

class RootViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
    
    
// MARK: - IBOutlet
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var tagField: UITextField!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var backgroundCameraView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
// MARK: - Properties
    var cameraBlurBackground: JMBackgroundCameraView?
    var confirmationView = UIView()
    var blockUIView = UIView()
    var confirmationViewHolder = ConfirmationView()
    var viewWidth:CGFloat?
    var viewHeight:CGFloat?
    var locationSelected: String?
    var contactsArray:[Contact] = []
    var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    let messageComposer = MessageComposer()
    let ContactsRealmDB = RealmDatabase()

// MARK: - SQlite DB Properties
//    let id = Expression<Int64>("id")
//    let name = Expression<String?>("name")
//    let phone = Expression<String>("phone")
//    let location = Expression<String>("location")
//    let tags = Expression<String>("tags")

// MARK: -
    
   
    
    
    
// MARK: -
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }
    
// MARK: - Show Confirmation View
    func showConfirmation(contatName: String){
        let size = self.screenSize()
        self.viewWidth = size.width
        self.viewHeight = size.height
        
        self.blockUIView = UIView(frame: CGRectMake(0, 0, self.viewWidth!, self.viewHeight!))
        self.blockUIView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
        
        // Add black transparent view that will contain our confirmationView
        self.view.addSubview(blockUIView)
    
        self.confirmationViewHolder.nameLabel.text = contatName
    
        self.confirmationView = UIView(frame: CGRectMake(self.viewWidth!/2, -500, 250, 210))
        self.confirmationView.bounds = CGRectMake(self.confirmationView.frame.size.width/2, self.confirmationView.frame.size.width/2, 250, 210)
        self.confirmationView.addSubview(confirmationViewHolder)
        self.blockUIView.addSubview(self.confirmationView)
        //self.confirmationView.addSubview(confirmationViewHolder)
        
        // Begin animation
        self.confirmationView.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            self.confirmationView.alpha = 1
        })
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.confirmationView.frame.origin.y = (self.viewHeight!/2) - 50
            }, completion: { finished in
        }) // End animation
        
    }
// MARK: -
    

    
    override func viewDidLoad() {
        self.leftBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "FontAwesome", size: 22)!], forState: UIControlState.Normal)
        self.leftBarButton.title = "\u{f013}"
        self.rightBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "FontAwesome", size: 22)!], forState: UIControlState.Normal)
        self.rightBarButton.title = "\u{f0c0}"
        
        self.selfieImage.layer.cornerRadius = self.selfieImage.frame.size.width / 2;
        self.selfieImage.clipsToBounds = true;
        
        self.cameraBlurBackground = JMBackgroundCameraView(frame: view.bounds, position: DevicePosition.Front, blur: UIBlurEffectStyle.Dark)
        self.backgroundCameraView.addSubview(self.cameraBlurBackground!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeContactConfirmationView:", name:"closeContactConfirmationView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendConfirmationSMSToNewContact:", name:"sendConfirmationSMSToNewContact", object: nil)
        
        self.phoneField.delegate = self
        self.tagListView.delegate = self
        self.tagListView.textFont = UIFont.systemFontOfSize(16)
        self.addLeftPaddingToTextfield(self.nameField)
        self.addLeftPaddingToTextfield(self.phoneField)
        self.addLeftPaddingToTextfield(self.locationField)
        self.addLeftPaddingToTextfield(self.tagField)
        
        self.confirmationViewHolder = UINib(nibName: "ConfirmationView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ConfirmationView
        //self.showConfirmation("John Doe")
        
        self.phoneField.addTarget(self, action: "maskPhoneField:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        // Realm Messages
        self.ContactsRealmDB.addNewContact()
        self.ContactsRealmDB.getAllContacts()
        
    }
    

// MARK: - Add Tags
    @IBAction func addTagToList(sender: AnyObject) {
        if self.tagField.text == "" {
            print("Tag field empty")
        } else {
            self.addTag()
        }
    }
    
    func addTag(){
        if self.tagListView.getAllTags().count == 10{
            print("Tag limit reached")
        } else {
            let tag:String = self.tagField.text!
            self.tagListView.addTag(tag).onTap = { tagView in
                self.tagListView.removeTagView(tagView)
            }
            self.tagField.resignFirstResponder()
            self.tagField.text = ""
        }
    }
 
// MARK: - Textfields
    func addLeftPaddingToTextfield(field: UITextField){
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = UITextFieldViewMode.Always
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //if textField == self.nameField{
            //self.phoneField.becomeFirstResponder()
//        }
//        else if textField == self.phoneField{
//            self.locationField.becomeFirstResponder()
//        } else if textField == self.locationField{
//            self.tagField.becomeFirstResponder()
//        } else if textField == self.tagField{
//            self.addTag()
//        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.locationField{
            performSegueWithIdentifier("rootSegue", sender: nil)
            return false
        }
//        else if textField == self.nameField {
//            return true
//        } else if textField == self.tagField {
//            return true
//        } else {
//            return true
//        }
        return true
    }
    
    
    func maskPhoneField(sender: AnyObject){
        if let textField = sender as? UITextField{
    
            if let currentPosition = textField.selectedTextRange{
                var isEndOfString = false
                let currentCurserPositionInteger = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: currentPosition.start)
                
                if currentCurserPositionInteger == textField.text!.characters.count{
                    isEndOfString = true
                }
                textField.text = returnMaskedPhoneField(textField.text!)
                if isEndOfString == false {
                    textField.selectedTextRange = currentPosition
                }
            } else {
                textField.text = returnMaskedPhoneField(textField.text!)
            }
            
        }
    }
    
    func returnMaskedPhoneField(thePhoneText:String)->String{
        var returnString = thePhoneText
        returnString = returnString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        returnString = returnString.stringByReplacingOccurrencesOfString("-", withString: "")
        returnString = returnString.stringByReplacingOccurrencesOfString("(", withString: "")
        returnString = returnString.stringByReplacingOccurrencesOfString(")", withString: "")
        if returnString.characters.count >= 1 {
            returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(0), end: returnString.indexAt(0)), withString: "(")
        }
        if returnString.characters.count > 4 {
            returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(4), end: returnString.indexAt(5)), withString: ") ")
        }
        if returnString.characters.count > 9 {
            returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(9), end: returnString.indexAt(9)), withString: "-")
        }
        return returnString
    }
    
    
    // Add character limit to [phoneField]
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneField{
            var newLength: Int?
            newLength = textField.text!.characters.count + string.characters.count - range.length
            return newLength! <= 14 // Bool
        } else {
            return true
        }
    }
// MARK: -
    
    
//    @IBAction func selectLocationBtn(sender: AnyObject) {
//        // nothing
//    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

//    @IBAction func viewContactList(sender: AnyObject) {
//        println("View Contact List")
//    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.locationSelected != nil{
            self.locationField.text = self.locationSelected
            //self.tagField.becomeFirstResponder()
        }
    }
    
    @IBAction func goBackToHome(segue: UIStoryboardSegue){
        //println("Return To Home")
    }
    
    @IBAction func saveContactBtn(sender: AnyObject) {
//        let db = Database("\(self.path)/db.sqlite3")
//        let contacts_db = db["contacts"]
//    
//        var userName = self.nameField.text
//        var userPhone = self.phoneField.text
//        var userLocation = self.locationField.text
//        var userTags = self.tagListView.getAllTags()
//        
//        if userName == ""{
//            self.showAlertMessage("Missing Field", message: "Name")
//        } else if userPhone == ""{
//            self.showAlertMessage("Missing Field", message: "Phone")
//        } else if userLocation == ""{
//            self.showAlertMessage("Missing Field", message: "Location")
//        } else {
//            var joiner = ",".join(userTags)
//            let insert = contacts_db.insert(name <- "\(userName)", phone <- "\(userPhone)", location <- "Fat Rabbits", tags <- "\(userTags)")
//            if let rowid = insert.rowid {
//                self.showConfirmation(userName)
//                //println("inserted id: \(rowid)")
//            } else if insert.statement.failed {
//                self.showAlertMessage("Uh oh, Try again", message: "Failed to add contact: \(insert.statement.reason)")
//            }
//        }
    }
    
    func showAlertMessage(title:String, message: String){
        JSSAlertView().danger(self, title: title, text: message)
    }
    
    
// MARK: - NSNotificationCenter Methods
    func closeContactConfirmationView(notification: NSNotification){
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.confirmationView.frame.origin.y = self.view.center.y + self.viewHeight!
            UIView.animateWithDuration(0.2, animations: {
                self.blockUIView.alpha = 0
            })
            }, completion: { finished in
                self.blockUIView.removeFromSuperview()
                self.confirmationView.removeFromSuperview()
            })
    }
    
    func sendConfirmationSMSToNewContact(notification: NSNotification){
        if(self.messageComposer.canSendText()){
            let messageComposerVC = messageComposer.configureMessageComposerViewController("Aldo Lugo", contactPhone: ["214-475-6999"])
            presentViewController(messageComposerVC, animated: true, completion: nil)
        }
    }
    
    
// MARK: - Camera Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selfieImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.selfieImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selfieImage.layer.cornerRadius = self.selfieImage.frame.size.width / 2;
        self.selfieImage.clipsToBounds = true;
        let imageData = UIImageJPEGRepresentation(self.selfieImage.image!, 0.5)
        print(imageData!.length)
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.cameraBlurBackground?.startTakingVideo()
        })
    }
    
    @IBAction func takePhotoBtn(sender: AnyObject) {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        self.imagePicker.allowsEditing = true
        self.cameraBlurBackground?.stopTakingVideo()
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }

    @IBAction func deleteImageView(sender: AnyObject) {
        self.selfieImage.image = UIImage(named: "Default Profile")
    }
}
