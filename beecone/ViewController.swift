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
        // 10s has elapsed
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
        self.myBeacon.text = "Searching..."
        self.didSomething.text = ""
        self.doSomethingState.enabled = false
        self.doSomethingState.hidden = true
        
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
    
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!)
    {
        if let foundBeacon = beacons.first as? CLBeacon
        {
            // got at least one beacon
//            self.myBeacon.text = foundBeacon.major.description + ":" + foundBeacon.minor.description + " (" + foundBeacon.rssi.description + "dB)"
//            self.myBeacon.text = foundBeacon.major == 22 ? "You are Upstairs (" + foundBeacon.rssi.description + "db)" : "You are Downstairs (" + foundBeacon.rssi.description + "db)"
            self.myBeacon.text = "Home"
            self.isInBeaconRange = true
            self.doSomethingState.enabled = true
            self.doSomethingState.hidden = false
            
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
                self.myBeacon.text = "Not home"
                self.isInBeaconRange = false
                self.doSomethingState.enabled = false
                self.didSomething.text = ""
                self.doSomethingState.hidden = true
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!)
    {
        self.timerRunning = false
        self.myBeacon.text = "Searching"
        self.isInBeaconRange = false
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        //        self.startButton.setTitle("Started", forState: UIControlState.Normal)
        // collecting the most recent location from the array of locations
        if let newLocation = locations.last as? CLLocation
        {
//            self.gpsSpeed = metresPerSecToMilesPerHour(newLocation.speed)
//            if self.gpsSpeed >= floatingZero
//            {
//                self.sampleCount++
//                self.gpsSpeedTotal += self.gpsSpeed
//                if sampleCount > floatingZero
//                {
//                    self.gpsAverageSpeed = gpsSpeedTotal / sampleCount
//                }
//            }
//            self.startButton.setTitle("Start", forState: UIControlState.Normal)
//            self.spinner.stopAnimating()
//            updateSpeedDisplay(self.gpsSpeed, average:self.gpsAverageSpeed)
        }
        else
        {
//            self.speed.text = " * "
//            self.averageSpeed.text = " * "
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
//        self.speed.text = noSignal
//        self.averageSpeed.text = noSignal
//        self.gpsSpeed = floatingZero
//        self.gpsAverageSpeed = floatingZero
//        self.sampleCount = floatingZero
//        self.gpsSpeedTotal = floatingZero
//        self.spinner.startAnimating()
        self.locationManager.stopUpdatingLocation()
    }

}

