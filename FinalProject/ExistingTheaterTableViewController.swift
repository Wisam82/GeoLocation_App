//
//  ExistingTheaterTableViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/29/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class ExistingTheaterTableViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    var TableDataKeys:Array< String > = Array < String >()
    var TheaterLongitudes:Array< String > = Array < String >()
    var TheaterLatitudes:Array< String > = Array < String >()
    
    var temp = 34.33333

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableData.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/theaters")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ExistingTheaterCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExistingTheaterTableViewCell
        cell.TheaterName.text = TableData[indexPath.row]
        cell.TheaterKey.text = TableDataKeys[indexPath.row]
        cell.TheaterLong.text = TheaterLongitudes[indexPath.row]
        cell.TheaterLat.text = TheaterLatitudes[indexPath.row]
        
        return cell
    }
    
    func NewdataTable () {
        TableData.removeAll()
        TheaterLongitudes.removeAll()
        TheaterLatitudes.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/theaters")
        
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
        
        print("Printing the logged in user name in controler");
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
            if let Theater_list = json as? NSArray {
                for theater in Theater_list {
                    if let TheaterEntry = theater as? NSDictionary {
                        if let Atheater = TheaterEntry["TheaterName"] as? String{
                            //println(Atheater);
                            TableData.append(Atheater);
                            
                        }
                        if let Theater_Key = TheaterEntry["keys"] as? NSNumber {
                            let aString = Theater_Key.stringValue
                            TableDataKeys.append((aString))
                            print("User favorite theater key")
                            print(aString);
                        }
                        if let Theater_longitude = TheaterEntry["longitude"] as? String{
                            print("We are in Longitude");
                            print(Theater_longitude);
                            //temp = (TheaterEntry["longitude"]as? Double)!;
                            //var temp2:String = String(format:"%f", temp)
                            //println(temp)
                            if Theater_longitude == "null" {
                                self.TheaterLongitudes.append("null");
                            }else {
                                self.TheaterLongitudes.append(Theater_longitude);
                            }
                        } else {
                            TheaterLongitudes.append("NoLong");
                        }
                        if let Theater_latitude = TheaterEntry["latitude"] as? String{
                            //println(Atheater);
                            print("We are in Latitude");
                            print(Theater_latitude);

                            //temp = (TheaterEntry["latitude"]as? Double)!;
                            //var temp3:String = String(format:"%7f", temp)
                            //println(temp)
                            
                            if Theater_latitude == "null" {
                                TheaterLatitudes.append("null");
                            }
                            else {
                                TheaterLatitudes.append(Theater_latitude);
                            }
                            
                            
                        } else {
                            TheaterLatitudes.append("NoLat");
                        }
                        
                    }
                }
            }
            
        }
        self.do_table_refresh();
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    @IBAction func CancelExistTheater(sender: AnyObject) {
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    


}
