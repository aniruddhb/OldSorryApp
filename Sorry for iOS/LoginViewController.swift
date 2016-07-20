//
//  LoginViewController.swift
//  Sorry for iOS
//
//  Created by Aniruddh Bharadwaj on 7/18/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        /* goal: login to facebook, and if succesful, segue to home screen */
        
        // declare login manager
        let facebookLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        
        // login with read permissions (for now)
        facebookLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            /* if there is an error (!= nil) or the action is cancelled, don't move forward. otherwise, login was successful, segue to tableview. */
            if error != nil || result.isCancelled {
                // TODO: Show user the proper error message / dialog
            } else {
                // segue to tableviewcontroller embedded in navigationcontroller
                self.performSegueWithIdentifier("FriendScreenSegue", sender: sender)
            }
        }
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
