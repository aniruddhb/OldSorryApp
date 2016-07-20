//
//  FriendsTableViewController.swift
//  Sorry for iOS
//
//  Created by Aniruddh Bharadwaj on 7/19/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FriendsTableViewController: UITableViewController {
    
    /* local variables */
    var facebookFriendsData: [Dictionary<String, AnyObject>] = []

    override func viewDidLoad() {
        // load superview
        super.viewDidLoad()
        
        // change the navigation bar's title
        self.title = "Friends"
        
        // load stories
        loadFriendsIntoTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* MARK: Self-Written Methods */
    func loadFriendsIntoTableView() {
        // declare parameters we want from the populable friends
        let params = ["fields" : "name"]
        
        // declare request to facebook graph API for taggable friends
        let requestingFriends = FBSDKGraphRequest(graphPath: "me/taggable_friends?limit=5000", parameters: params)
        
        // show loading animation
        self.view.showLoading()
        
        // start request
        requestingFriends.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) in
            // if error is nil, iterate through JSON and push data to local friends array
            if error == nil {
                // assign given data to local holding variable
                self.facebookFriendsData = result["data"] as! [Dictionary<String, AnyObject>]
            }
            
            // hide loading animation
            self.view.hideLoading()
            
            // reload tableview data
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of friends in local variable
        return facebookFriendsData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FriendTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell

        // Configure the cell...
        cell.friendName.text = facebookFriendsData[indexPath.row]["name"] as? String ?? "Friend failed to load"

        return cell
    }
}
