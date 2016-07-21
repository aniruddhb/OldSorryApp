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
    
    // local array for flatui colors
    var flatUIColors: [String] = ["1abc9c", "16a085", "f1c40f", "f39c12", "2ecc71", "27ae60", "e67e22", "d35400", "3498db", "2980b9", "e74c3c", "c0392b", "9b59b6", "8e44ad", "34495e", "2c3e50"]

    override func viewDidLoad() {
        // load superview
        super.viewDidLoad()
        
        // change the navigation bar's title
        self.title = "Friends"
        
        // load stories
        loadFriendsIntoTableView()
        
        // define parameters for searchcontroller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // define properties for tableview
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .None
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
        // grab cell with identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell

        // if user isn't searching, return data from full array, but if user is, return from filtered list
        if searchController.active && searchController.searchBar.text != "" {
            cell.friendName.text = filteredFriendsData[indexPath.row]["name"] as? String
        } else {
            cell.friendName.text = facebookFriendsData[indexPath.row]["name"] as? String
        }

        // set font weight for label
        cell.friendName.font = UIFont(name: "Avenir Next", size: 42)
        
        // adjust properties of label
        cell.friendName.adjustsFontSizeToFitWidth = true
        
        // adjust cell color
        cell.backgroundColor = UIColor(hex: flatUIColors[Int(arc4random_uniform(UInt32(flatUIColors.count)))])
        
        // return properly configured cell
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // deselect the selected row instead of preserving animation
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

/* class extensions for search feature */
extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterFriendsContent(searchController.searchBar.text!)
    }
}