//
//  MapViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/29/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var TheaterMap: MKMapView!
    
    var TheaterName = String()
    var TheaterKey = String()
    var Theaterlongitude = String()
    var Theaterlatitude = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the stored Theater info
        let StoredTheaterName = NSUserDefaults.standardUserDefaults().stringForKey("TheaterName");
        let StoredTheaterKey = NSUserDefaults.standardUserDefaults().stringForKey("TheaterKey");
        TheaterKey = StoredTheaterKey!
        
        let StoredTheaterLong = NSUserDefaults.standardUserDefaults().stringForKey("TheaterLong");
        
        let StoredTheaterLat = NSUserDefaults.standardUserDefaults().stringForKey("TheaterLat");
        
        // Print statement for debugging
        // println("Theater Long as string is ")
        // println(StoredTheaterLong)
        // println("Theater Lat as string is ")
        // println(StoredTheaterLat)
        
        let LongitudeNSString = StoredTheaterLong! as NSString
        let TheaterlongitudeInt = (LongitudeNSString.doubleValue)
        
        let LatitudeNSString = StoredTheaterLat! as NSString
        let TheaterlatitudeInt = LatitudeNSString.doubleValue
        
        // Print statement for debugging
        // println("Theater Long as stringis ")
        // println(TheaterlongitudeInt)
        // println("Theater Lat as string is ")
        // println(TheaterlatitudeInt)
        
        // Create the map pin coordination based on the API result of Lat and Long
        
        let location = CLLocationCoordinate2DMake(TheaterlatitudeInt,
            TheaterlongitudeInt)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        TheaterMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        
        // Add a title and subtitle to the pin
        annotation.title = StoredTheaterName
        annotation.subtitle = "Latitude: " + StoredTheaterLat! + " Longitude: " + StoredTheaterLong!
        
        TheaterMap.addAnnotation(annotation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    
    @IBAction func CancelMap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true,completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
