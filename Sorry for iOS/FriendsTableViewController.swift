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
    
    // full friend data holder
    var facebookFriendsData: [Dictionary<String, AnyObject>] = []
    
    // filtered friend data holder
    var filteredFriendsData: [Dictionary<String, AnyObject>] = []
    
    // search controller
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        // load superview
        super.viewDidLoad()
        
        // change the navigation bar's title
        self.title = "Friends"
        
        // load stories
        loadFriendsIntoTableView()
        
        // define parameters for searchcontroller
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
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
    
    func filterFriendsContent(searchText: String, scope: String = "ALL") {
        // filter all friends data into filtered list based on search text
        filteredFriendsData = facebookFriendsData.filter({ (friendEntry: [String : AnyObject]) -> Bool in
            return (friendEntry["name"]?.lowercaseString.containsString(searchText.lowercaseString))!
        })
        
        // reload tableview
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if search field is active and non-empty, return number of filtered friend results
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFriendsData.count
        }
        
        // otherwise, return number of friends
        return facebookFriendsData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FriendTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell

        // if user isn't searching, return data from full array, but if user is, return from filtered list
        if searchController.active && searchController.searchBar.text != "" {
            cell.friendName.text = filteredFriendsData[indexPath.row]["name"] as? String
        } else {
            cell.friendName.text = facebookFriendsData[indexPath.row]["name"] as? String
        }

        return cell
    }
}

/* class extensions for search feature */
extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterFriendsContent(searchController.searchBar.text!)
    }
}