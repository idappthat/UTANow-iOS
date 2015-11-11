//
//  LoginViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit

import Parse
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    @IBAction func actionLoginWithFacebook(sender: AnyObject) {
        let permissions = ["public_profile", "email", "user_friends", "user_birthday"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user, error) -> Void in
            if user != nil {
                self.finishLoggingInWithParse(user!)
            }
        })
    }
    
    @IBAction func actionSkip(sender: AnyObject) {
        performSegueWithIdentifier("eventListSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Logged out")
        } else {
            print("Logged in")
            FBSDKLoginManager().logOut()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get basic Facebook Data - use user.isNew to check if new
    func finishLoggingInWithParse(user: PFUser) {
        let paramFields = "id, first_name, last_name, picture.type(large), email, gender"
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": paramFields]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil){
                //TODO: Check for nil values
                
                //Get basic profile data
                let data = result as! NSDictionary
                user["email"] = data.objectForKey("email") as! String
                user["firstName"] = data.objectForKey("first_name") as! String
                user["lastName"] = data.objectForKey("first_name") as! String
                user["gender"] = data.objectForKey("gender") as! String
                
                //Get profile Image
                let imageData = data.objectForKey("picture")?.objectForKey("data")
                if let noImage = imageData?.objectForKey("is_silhouette") {
                    if !(noImage as! Bool) {
                        user["profilePicture"] = imageData?.objectForKey("url")
                    }
                }
                
                user.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        self.performSegueWithIdentifier("eventListSegue", sender: self)
                    }
                })
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
        }
    }
    
}
