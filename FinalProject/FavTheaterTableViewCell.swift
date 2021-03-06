//
//  FavTheaterTableViewCell.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/29/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class FavTheaterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var FavTheaterName: UILabel!
    
    @IBOutlet weak var FavTheaterKey: UILabel!
    
    
    var TheaterKey = String()
    var UserId = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func RemoveTheaterFromList(sender: AnyObject) {
        
        TheaterKey = FavTheaterKey.text!;
        print("Theater key to remove")
        print(TheaterKey)
        // Get the stored Username ID
        let LoggedInUserID = NSUserDefaults.standardUserDefaults().stringForKey("LoggedInUserKey");
        
        UserId = LoggedInUserID!;
        print("USerID to remove")
        print(UserId)
        Remove_theater_from_user_list();
    }
    // Send a PUT request to add new movie to user
    func Remove_theater_from_user_list() {
        var status : Bool
        var Params: String
        
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://finalproject-1137.appspot.com/User/"+UserId+"/theater/"+TheaterKey);
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "DELETE";
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
    
    @IBAction func SaveCellDataForMap(sender: AnyObject) {
        
        // Store Theater Name and Key
        NSUserDefaults.standardUserDefaults().setObject(FavTheaterName.text, forKey: "TheaterName");
         NSUserDefaults.standardUserDefaults().setObject(FavTheaterKey.text, forKey: "TheaterKey");
        NSUserDefaults.standardUserDefaults().synchronize();
        
    }
    
    

}
