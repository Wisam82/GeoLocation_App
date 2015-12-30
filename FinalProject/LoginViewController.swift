//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/23/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var UserUsernameTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlertMessage(userMessage: String) {
        
        let alert = UIAlertController(title: "Error", message: userMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default , handler: {(alertAction)in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Send a POST request to log user in
    func Login_Post() -> String {
        // Handle the text field’s user input through delegate callbacks.
        UserUsernameTextField.delegate = self
        UserPasswordTextField.delegate = self
        var status : Bool
        var Params: String
        var RetrunedValue : String = "Some Text"
        
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://finalproject-1137.appspot.com/User/Login");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        Params = "username=";
        Params += UserUsernameTextField.text;
        Params += "&password=";
        Params += UserPasswordTextField.text;
        //println("Params is =\(Params)")
        let postString = Params;
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
        return RetrunedValue
        
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
                    let retrunedMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    var retrunedSucsessMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    // Dispaly alert message with the server response
//                    var alert = UIAlertController(title: "Confirmation", message: retrunedSucsessMessage, preferredStyle: .Alert)
//                    let okAction = UIAlertAction(title: "Okay", style: .Default ){ action in
//                        self.dismissViewControllerAnimated(true,completion: nil)
//                    }
                    // Store a logged in flag to use during the session
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IsUserLoggedIn");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    
                    // Store User ID and Username
                    NSUserDefaults.standardUserDefaults().setObject(UserUsernameTextField.text, forKey: "LoggedInUser");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    
                    // Display results
//                    alert.addAction(okAction);
//                    self.presentViewController(alert, animated: true, completion: nil);
                    
                    // Login
                    self.dismissViewControllerAnimated(true,completion: nil)
                    
                } else {
                    //If response return false, dispaly alert message with the server response
                    let retrunedMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    self.displayAlertMessage(retrunedMessage!)
                }
                
            }
        }
    }
    
    
    
    // MARK: Actions
    
    @IBAction func LoginButton(sender: AnyObject) {
        
        let UserUsername = UserUsernameTextField.text
        let UserPassword = UserPasswordTextField.text
        
        // Checking for empty fields
        if (UserUsername.isEmpty || UserPassword.isEmpty) {
            // Display an alert
            
            displayAlertMessage("All Fields are required...");
            
            return;
        }
        // Check for Authorization with the database if the user is valid
        var SingupStatusMessage = Login_Post();
    
        
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
