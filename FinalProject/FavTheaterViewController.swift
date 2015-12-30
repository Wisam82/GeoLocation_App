//
//  FavTheaterViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/27/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class FavTheaterViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    var TableDataKeys:Array< String > = Array < String >()
    var refreshFlag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableData.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/User")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return TableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FavTheaterCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavTheaterTableViewCell
        
        cell.FavTheaterName.text = TableData[indexPath.row]
        cell.FavTheaterKey.text = TableDataKeys[indexPath.row]
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        if refreshFlag > 0 {
            self.NewdataTable()
        }
        
    }
    func NewdataTable () {
        TableData.removeAll()
        TableDataKeys.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/User")
        
    }
    func get_data_from_url(url:String)
    {
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse?,
                data: NSData?,
                error: NSError?) in
                if data.length > 0 && error == nil{
                    let json = NSString(data: data, encoding: NSASCIIStringEncoding)
                    self.extract_json(json!)
                }else if data.length == 0 && error == nil{
                    print("Nothing was downloaded")
                } else if error != nil{
                    print("Error happened = \(error)")
                }
            }
        )
    }
    func extract_json(data:NSString)
    {
        // Get the stored Username
        let LoggedInUser = NSUserDefaults.standardUserDefaults().stringForKey("LoggedInUser");
        print(LoggedInUser);
        
        var new_url: String
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        } catch let error as NSError {
            parseError = error
            json = nil
        }
        if (parseError == nil)
        {
            if let Users = json as? NSArray {
                for item in Users {
                    if let UserEntry = item as? NSDictionary {
                        // From the users list select only the logged in User
                        if let AUser = UserEntry["Username"] as? String{
                            if AUser == LoggedInUser {
                                // Get the user's favorite movie list
                                if let FavTheaterList = UserEntry["Favorite_Theaters"] as? NSArray {
                                    for theater in FavTheaterList {
                                        if let TheaterName = theater["Theater_name"] as? String {
                                            //println(movieName);
                                            TableData.append(TheaterName);
                                        }
                                        if let Theater_Key = theater["Theater_key"] as? NSNumber {
                                            let KeyString = Theater_Key.stringValue
                                            TableDataKeys.append((KeyString))
                                            print(Theater_Key);
                                        }
                                        
                                    }
                                }
                                if let UserKey = UserEntry["keys"] as? NSNumber {
                                    let KeyString = UserKey.stringValue
                                    print(KeyString)
                                    // Store User ID
                                    NSUserDefaults.standardUserDefaults().setObject(KeyString, forKey: "LoggedInUserKey");
                                    NSUserDefaults.standardUserDefaults().synchronize();
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        refreshFlag = 1
        self.do_table_refresh();
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    // MARK: Actions
    @IBAction func TheaterBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true,completion: nil)
        
    }
    
    
    @IBAction func RefreshFavTheater(sender: AnyObject) {
        TableData.removeAll()
        TableDataKeys.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/User")
        
    }
    

}

