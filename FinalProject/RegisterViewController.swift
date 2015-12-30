//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by Wisam Thalij on 11/23/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,  UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    @IBOutlet weak var UserRepeatedPasswordTextField: UITextField!
    
    @IBOutlet weak var SigUpResults: UILabel!
    
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
    
    // Send a POST request to add new User
    func SignUp_Post() -> String {
        // Handle the text field’s user input through delegate callbacks.
        UsernameTextField.delegate = self
        UserPasswordTextField.delegate = self
        var status : Bool
        var Params: String
        var RetrunedValue : String = "Some Text"
        
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://finalproject-1137.appspot.com/User/Signup");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        Params = "username=";
        Params += UsernameTextField.text;
        Params += "&password=";
        Params += UserPasswordTextField.text;
        print("Params is =\(Params)")
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
                    let UserDBName = parseJSON["username"] as? String
                    print("UserDBName: \(UserDBName!)")
                    
                    let UserDBPassword = parseJSON["password"] as? Int
                    if let newPass = UserDBPassword {
                        print(newPass)
                    }
                    let KeyNum = parseJSON["key"] as? NSNumber
                    if let newkey = KeyNum {
                        print(newkey)
                    }
                    let retrunedMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    let retrunedSucsessMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    self.SigUpResults.text = retrunedMessage
                    // Dispaly alert message with the server response
                    let alert = UIAlertController(title: "Confirmation", message: retrunedSucsessMessage, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Okay", style: .Default ){ action in
                        self.dismissViewControllerAnimated(true,completion: nil)
                    }
                    alert.addAction(okAction);
                    self.presentViewController(alert, animated: true, completion: nil);
                    
                } else {
                    //If response return false, dispaly alert message with the server response
                    let retrunedMessage = parseJSON["message"] as? String
                    print("message: \(retrunedMessage)")
                    
                    self.SigUpResults.text = retrunedMessage
                    
                    self.displayAlertMessage(retrunedMessage!)
                }
                
            }
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func SignupButton(sender: AnyObject) {
        
        let UserUsername = UsernameTextField.text;
        let UserPassword = UserPasswordTextField.text;
        let UserRepeatedPassword = UserRepeatedPasswordTextField.text;
        
        // Checking for empty fields
        if (UserUsername.isEmpty || UserPassword.isEmpty || UserRepeatedPassword.isEmpty) {
            // Display an alert
            
            displayAlertMessage("All Fields are required...");
            
            return;
        }
        
        // Checking for password matching
        
        if (UserPassword != UserRepeatedPassword) {
            // Display an alert
            
            displayAlertMessage("Passwords did not match! try again...");
            
            return;
        }
        // Register the user in the database
         var SingupStatusMessage = SignUp_Post();
    }
    
    @IBAction func GoToLoginButton(sender: AnyObject) {
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
