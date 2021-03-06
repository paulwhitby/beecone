//
//  ViewController.swift
//  beecone
//
//  Created by Paul Whitby on 04/07/2015.
//  Copyright (c) 2015 Paul Whitby. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var myBeacon: UILabel!
    @IBOutlet weak var doSomethingState: UIButton!
    @IBOutlet weak var didSomething: UILabel!
    
    var locationManager = CLLocationManager()
    var location = CLLocation()
    var rangingAvailable = CLLocationManager.isRangingAvailable()
    var beacon = CLBeacon()
    
    let pibeaconUUID   = NSUUID(UUIDString: "59313754-8369-42BF-8B14-7E5C8632BF05") //   futureproofing
    let homeUUID       = NSUUID(UUIDString: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    
    var upperBeaconRegion = CLBeaconRegion()
    var lowerBeaconRegion = CLBeaconRegion()
    
    var isInBeaconRange = false
    
    var timer = NSTimer()
    var timerRunning = false

    let kTimeInterval = 10.0 // seconds

    
    @objc func timerFireMethod(timer:NSTimer)
    {
        // kTimeInterval has elapsed since a beacon region was detected
        self.timerRunning = false
    }

    
    @IBAction func doSomething(sender: AnyObject)
    {
        self.didSomething.text = "Did something!"
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.beaconInRange(false, withMessage:"Searching...")
        self.didSomething.text = ""
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        upperBeaconRegion = CLBeaconRegion(proximityUUID: self.homeUUID, major: 22, minor: 8,  identifier: "Upstairs")
        lowerBeaconRegion = CLBeaconRegion(proximityUUID: self.homeUUID, major: 24, minor: 10, identifier: "Downstairs")
        upperBeaconRegion.notifyEntryStateOnDisplay = true
        lowerBeaconRegion.notifyEntryStateOnDisplay = true
        self.locationManager.startRangingBeaconsInRegion(lowerBeaconRegion)
        self.locationManager.startRangingBeaconsInRegion(upperBeaconRegion)

        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func beaconInRange(isInRange:Bool)
    {
        self.isInBeaconRange = isInRange
        self.doSomethingState.enabled = self.isInBeaconRange
        self.doSomethingState.hidden = !self.isInBeaconRange
    }
    
    func beaconInRange(isInRange:Bool, withMessage aMessage:String)
    {
        self.beaconInRange(isInRange)
        self.myBeacon.text = aMessage
    }
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!)
    {
        if let foundBeacon = beacons.first as? CLBeacon
        {
            // got at least one beacon
//            self.myBeacon.text = foundBeacon.major.description + ":" + foundBeacon.minor.description + " (" + foundBeacon.rssi.description + "dB)"
//            self.myBeacon.text = foundBeacon.major == 22 ? "You are Upstairs (" + foundBeacon.rssi.description + "db)" : "You are Downstairs (" + foundBeacon.rssi.description + "db)"

            self.beaconInRange(true, withMessage:"Home")
            
            if !self.timerRunning
            {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(kTimeInterval, target:self, selector: Selector("timerFireMethod:"), userInfo: nil, repeats: false)
                self.timerRunning = true
            }
        }
        else
        {
            if !self.timerRunning
            {
                self.beaconInRange(false, withMessage:"Not home")
                self.didSomething.text = ""
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!)
    {
        self.timerRunning = false
        self.beaconInRange(false, withMessage:"Searching")
        self.didSomething.text = ""
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let newLocation = locations.last as? CLLocation
        {
        }
        else
        {
        }
//        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
//        self.locationManager.stopUpdatingLocation()
    }

}

