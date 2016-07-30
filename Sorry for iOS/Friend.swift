//
//  Friend.swift
//  Sorry for iOS
//
//  Created by Aniruddh Bharadwaj on 7/20/16.
//  Copyright © 2016 Aniruddh Bharadwaj. All rights reserved.
//

import Foundation

class Friend {
    /* class description */

    /* the friend class is the M of MVC, and has 2 properties (for now).
       these properties are name and background color (solely used for
       the search feature for this app. in the future, email and other
       fb user information may be added to this model
    */
    
    // the name for this friend
    var friendName: String = ""
    
    // the background color for this friend (string rep. of hex)
    var friendBackgroundColor: String = ""
    
    // constructor function: constructs this friend
    func configureFriendProperties(name: String, color: String) {
        // set global identifiers to local values
        friendName = name
        friendBackgroundColor = color
    }
}
