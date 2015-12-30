//
//  MoviesTableViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/28/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
     var TableData:Array< String > = Array < String >()
    var TableDataKeys:Array< String > = Array < String >()

    override func viewDidLoad() {
        super.viewDidLoad()
        TableData.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/movies")
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
        let cellIdentifier = "ExistingMovieCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExistingMoviesTableViewCell
        cell.ExistingMovieName.text = TableData[indexPath.row]
        cell.ExistingMovieKey.text = TableDataKeys[indexPath.row]
        return cell
    }
    
    func NewdataTable () {
        TableData.removeAll()
        self.get_data_from_url("http://finalproject-1137.appspot.com/movies")
        
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
            if let Movies_list = json as? NSArray {
                for movie in Movies_list {
                    if let MovieEntry = movie as? NSDictionary {
                        if let Amovie = MovieEntry["MovieName"] as? String{
                            print(Amovie);
                            TableData.append(Amovie);
                            
                        }
                        if let Movie_Key = MovieEntry["keys"] as? NSNumber {
                            let aString = Movie_Key.stringValue
                            TableDataKeys.append((aString))
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
    
    // MARK: Actions
    
    @IBAction func CancelExistingMovies(sender: AnyObject) {
        self.dismissViewControllerAnimated(true,completion: nil)
        
    }

}
