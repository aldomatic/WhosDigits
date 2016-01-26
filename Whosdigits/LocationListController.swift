//
//  LocationListController.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 8/21/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SnapKit

class LocationListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var locationsArray:[String] = []
    let locationManager = CLLocationManager()
    var cords:[Double] = []
    var selectedLocation: String?
    var activityHolder = UIView()
    var networkIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var metrics = [String: Int]()
    //var foursquareTopLevelCategories = ["Art & Entertainment", "College & University", "Events & Gatherings", "Food & Restaurants", "Club & Bars", "Outdoors & Recreation"]
    var foursquareTopLevelCategoriesDic:[String: String] = ["Art & Entertainment" : "4d4b7104d754a06370d81259", "College & University" : "4d4b7105d754a06372d81259", "Events & Gatherings" : "EG", "Food & Restaurants" : "FR", "Club & Bars" : "CB", "Outdoors & Recreation" : "OR"]
    
    func loadActivityView(){
        self.activityHolder.translatesAutoresizingMaskIntoConstraints = false
        self.activityHolder.restorationIdentifier = "networkView"
        self.activityHolder.backgroundColor = UIColor.blackColor()
        self.activityHolder.alpha = 0.7
    
        self.networkIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.networkIndicator.startAnimating()
        
        self.activityHolder.addSubview(self.networkIndicator)
        self.tableHolderView.addSubview(self.activityHolder)
        
        
        self.activityHolder.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.center.equalTo(self.view)
            
        }
        
        
        
//        var dic = ["activity": self.activityHolder, "table":self.tableHolderView]
//        self.metrics = ["width": 100, "height": 100]
//        var h = NSLayoutConstraint.constraintsWithVisualFormat("V:[table]-(<=0)-[activity(width)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: self.metrics, views: dic)
//        var v = NSLayoutConstraint.constraintsWithVisualFormat("H:[table]-(<=0)-[activity(height)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: self.metrics, views: dic)
////
//        var w: NSLayoutConstraint = NSLayoutConstraint(item: self.activityHolder, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.tableHolderView
//        , attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 100)
//        var h: NSLayoutConstraint = NSLayoutConstraint(item: self.activityHolder, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.tableHolderView, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: 100)
//        

//        self.tableHolderView.addConstraint(w)
//        self.tableHolderView.addConstraint(h)
        
        
        
//        self.tableHolderView.addConstraints(h)
//        self.tableHolderView.addConstraints(v)
    }
    
    
//    @IBAction func anim(sender: AnyObject) {
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.activityHolder.snp_updateConstraints({ (make) -> Void in
//                make.width.equalTo(190)
//                make.height.equalTo(190)
//            })
//            self.tableHolderView.layoutIfNeeded()
//        })
//    }
    
    @IBOutlet weak var navigatoinBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
        tableView.backgroundColor = UIColor(red: 0.075, green: 0.075, blue: 0.075, alpha: 1.00)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadActivityView()
        self.getLocation()
        //println(self.tableHolderView.subviews[1].restorationIdentifier!!)
    }
    
    let catTest: String = "4d4b7105d754a06376d81259"
    func getVenues(lat lat:Double, lng: Double){
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, "http://crowdslike.com/api/venues/\(lat)/\(lng)/\(catTest)").responseJSON { response in
            var json = JSON(response.data!)
            for (var i = 0; i < json.count; i++){
                self.locationsArray.append(json[i]["name"].string!)
            }
            self.tableView.reloadData()
            self.networkIndicator.stopAnimating()
            self.activityHolder.hidden = true
        }
        
//        Alamofire.request(.GET, "http://crowdslike.com/api/venues/\(lat)/\(lng)/\(catTest)")
//            .responseJSON { _, _, data in
//                var json = JSON(data!)
//                for (var i = 0; i < json.count; i++){
//                    self.locationsArray.append(json[i]["name"].string!)
//                }
//                self.tableView.reloadData()
//                self.networkIndicator.stopAnimating()
//                self.activityHolder.hidden = true
//        }
        
    }

    
    // MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! RootViewController
        vc.locationSelected = self.selectedLocation
    }

    
    func getLocation(){
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startMonitoringSignificantLocationChanges()
        } else {
            print("Location services not enabled")
        }
    }
    
  
    
    // MARK: - Core Location Delegate
    func locationManager(manager: CLLocationManager,   didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.cords = [locValue.latitude, locValue.longitude]
        self.locationManager.stopMonitoringSignificantLocationChanges()
        self.getVenues(lat: self.cords[0], lng: self.cords[1])
    }
    
    
    // MARK: - Table View
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.locationsArray[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.075, green: 0.075, blue: 0.075, alpha: 1.00)
        cell.textLabel?.textColor = UIColor(red: 0.820, green: 0.812, blue: 0.373, alpha: 1.00)
    
        return cell
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationsArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedLocation = self.locationsArray[indexPath.row]
        self.performSegueWithIdentifier("backHome", sender: self)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
 
    
// MARK: - Category List Menu
    @IBAction func showCategoryViewBtn(sender: AnyObject) {
        self.showCategoryMenu()
    }
    
    var viewWidth:CGFloat?
    var viewHeight:CGFloat?
    var categoryView = UIView()
    var blockUIView = UIView()
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }
    

    func showCategoryMenu(){
        let size = self.screenSize()
        self.viewWidth = size.width
        self.viewHeight = size.height
        
        self.blockUIView = UIView(frame: CGRectMake(0, 0, self.viewWidth!, self.viewHeight!))
        self.blockUIView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
        self.categoryView = UIView(frame: CGRectMake(0, 0, 250, 305))
        self.categoryView.backgroundColor = UIColor(red: 0.104, green: 0.104, blue: 0.104 , alpha: 1)
        self.view.addSubview(blockUIView)
        self.blockUIView.addSubview(self.categoryView)
    
        
        // Start Foursquare Categories
        var catBtnYSpacing: CGFloat = 0
        for (category, _) in self.foursquareTopLevelCategoriesDic{
            let catBtn = UIButton(frame: CGRectMake(0, catBtnYSpacing, self.categoryView.frame.width, 50))
            catBtn.addTarget(self, action: "categoryButtonHighlight:", forControlEvents: UIControlEvents.TouchUpInside)
            catBtn.addTarget(self, action: "categoryButtonDefault:", forControlEvents: UIControlEvents.TouchDown)
            catBtn.setTitle(category, forState: UIControlState.Normal)
            catBtn.backgroundColor = UIColor(red: 0.506, green: 0.502, blue: 0.200 , alpha: 1)
            catBtn.setTitleColor(UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1), forState: UIControlState.Normal)
            self.categoryView.addSubview(catBtn)
            catBtnYSpacing += 51
        }
        // End Foursquare Categories

        self.categoryView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(305)
            make.centerX.equalTo(self.blockUIView)
            make.centerY.equalTo(0)
        }
        
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.categoryView.frame.origin.y = self.viewHeight!/2
            }, completion: { finished in
        })
         //End animation
    }
    
    
    func categoryButtonDefault(sender: UIButton){
        sender.backgroundColor = UIColor(red: 0.448, green: 0.445, blue: 0.175 , alpha: 1)
    }
    func categoryButtonHighlight(sender: UIButton){
        sender.backgroundColor = UIColor(red: 0.565, green: 0.561, blue: 0.224 , alpha: 1)
        print(self.foursquareTopLevelCategoriesDic[sender.currentTitle!]!)
        //self.getVenues(lat: self.cords[0], lng: self.cords[1])
        UIView.animateWithDuration(0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.categoryView.frame.origin.y = self.view.center.y + self.viewHeight!
            UIView.animateWithDuration(0.2, animations: {
                self.blockUIView.alpha = 0
            })
            }, completion: { finished in
                self.blockUIView.removeFromSuperview()
                self.categoryView.removeFromSuperview()
        })
    }
    
    // MARK: -
}

