//
//  ExistingTheaterTableViewCell.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/29/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class ExistingTheaterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TheaterName: UILabel!
    
    @IBOutlet weak var TheaterKey: UILabel!
    
    @IBOutlet weak var TheaterLong: UILabel!
    
    
    @IBOutlet weak var TheaterLat: UILabel!
    
    
    var FavTheaterKey = String()
    var UserId = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func Add_theater_to_user_list(sender: AnyObject) {
        
        FavTheaterKey = TheaterKey.text!;
        print("Printing the FavTheaterKey to add")
        print(FavTheaterKey)
        // Get the stored Username ID
        let LoggedInUserID = NSUserDefaults.standardUserDefaults().stringForKey("LoggedInUserKey");
        
        UserId = LoggedInUserID!;
        print("Printing the LoggedInUserID to add")
        print(UserId)
        Add_theater_to_user_list();
    }
    // Send a PUT request to add new theater to user
    func Add_theater_to_user_list() {
        var status : Bool
        var Params: String
        
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://finalproject-1137.appspot.com/User/"+UserId+"/theater/"+FavTheaterKey);
        print("Printing the URL to add")
        print(myUrl)
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "PUT";
        let postString = "";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        // Make the request on the backgroung thread
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return;
            }
            // Wait for the threat to ccomeback to main
            dispatch_async(dispatch_get_main_queue(), {
                
                self.setLables(data);
            })
            
            // print out response object
            print("******* response = \(response)")
            
            
            // print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("************ response data = \(responseString)")
            
        }
        
        task.resume()
        
    }
    // Set up the result of the Signup call, filter the JSON and display results
    func setLables(SignupData: NSData) {
        var err: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(SignupData, options: .MutableContainers) as? NSDictionary
        
        if let parseJSON = json {
            
            var status : Bool? = true
            if let SignupStatus = parseJSON["Sucess"] as? Bool {
                if (SignupStatus == true) {
                    print("SignupStatus: \(SignupStatus)")
                    
                } else {
                    print("Status is false")
                }
                
            }
        }
    }
    
    // Send a GET request to get Theater location
    func get_theater_info() {
        var status : Bool
        var Params: String
        
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://finalproject-1137.appspot.com/theater/"+FavTheaterKey);
        print("Printing the URL to add")
        print(myUrl)
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "PUT";
        let postString = "";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        // Make the request on the backgroung thread
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return;
            }
            // Wait for the threat to ccomeback to main
            dispatch_async(dispatch_get_main_queue(), {
                
                self.setLables2(data);
            })
            
            // print out response object
            print("******* response = \(response)")
            
            
            // print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("************ response data = \(responseString)")
            
        }
        
        task.resume()
        
    }
    // Set up the result of the Signup call, filter the JSON and display results
    func setLables2(SignupData: NSData) {
        var err: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(SignupData, options: .MutableContainers) as? NSDictionary
        
        if let parseJSON = json {
            
            var status : Bool? = true
            if let SignupStatus = parseJSON["Sucess"] as? Bool {
                if (SignupStatus == true) {
                    print("SignupStatus: \(SignupStatus)")
                    
                } else {
                    print("Status is false")
                }
                
            }
        }
    }
    
    @IBAction func SaveThaterInfoForMap(sender: AnyObject) {
        // Store Theater Name and Key
        NSUserDefaults.standardUserDefaults().setObject(TheaterName.text, forKey: "TheaterName");
        NSUserDefaults.standardUserDefaults().setObject(TheaterKey.text, forKey: "TheaterKey");
        NSUserDefaults.standardUserDefaults().setObject(TheaterLong.text, forKey: "TheaterLong");
        NSUserDefaults.standardUserDefaults().setObject(TheaterLat.text, forKey: "TheaterLat");
        NSUserDefaults.standardUserDefaults().synchronize();
        
    }
    
    
    
    

}
