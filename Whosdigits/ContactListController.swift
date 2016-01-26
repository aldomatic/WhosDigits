//
//  ContactListController.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 8/19/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit
import SQLite

class ContactListController: UIViewController, UITableViewDelegate {

   @IBOutlet weak var listTable: UITableView!
    var contactNames = Array<String>()
    var namesArray:[(name: String, phone: String, location: String, tags: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTable.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //self.namesArray = Db().getAllContacts()
        print(self.namesArray[0].3)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Contact_Cell", forIndexPath: indexPath) as! ContactCell
        cell.contactName.text = self.namesArray[indexPath.row].0
        cell.contactPhone.text = self.namesArray[indexPath.row].1
        cell.contactLocation.text = self.namesArray[indexPath.row].2
        cell.contactTags.text = self.namesArray[indexPath.row].3
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    
}
