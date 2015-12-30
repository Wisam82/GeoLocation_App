//
//  ViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/23/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("IsUserLoggedIn");
        // If user is not logged in display the login Page
        if (!isUserLoggedIn) {
            self.performSegueWithIdentifier("ToLoginView", sender: self)
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func LogoutButton(sender: AnyObject) {
        
        // Set the login flag to false when logged out
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "IsUserLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.performSegueWithIdentifier("ToLoginView", sender: self)
    }
    
    @IBAction func FavoriteMovies(sender: UIButton) {
        self.performSegueWithIdentifier("ToFavMovie", sender: self)
        
    }
    
    

}

